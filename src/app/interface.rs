use eframe::egui;
use egui::Color32;

use crate::{App, CaptureState, LogLevel};

impl LogLevel {
    fn color(&self) -> Color32 {
        match self {
            Self::Error => Color32::from_rgb(0xC6, 0x20, 0x20), // RED
            Self::Warning => Color32::from_rgb(0xC6, 0x51, 0x00), // ORANGE
            Self::Info => Color32::from_rgb(0x3C, 0x3C, 0x3C),  // GREY
            Self::Success => Color32::from_rgb(0x20, 0x51, 0x20), // GREEN
        }
    }
}

pub fn options() -> eframe::NativeOptions {
    eframe::NativeOptions {
        viewport: egui::ViewportBuilder::default()
            .with_inner_size([700.0, 480.0])
            .with_resizable(false),
        ..Default::default()
    }
}

pub fn initialize(creation_context: &eframe::CreationContext<'_>) {
    creation_context.egui_ctx.set_zoom_factor(1.2);
}

impl eframe::App for App {
    fn update(&mut self, context: &egui::Context, _frame: &mut eframe::Frame) {
        let log_color = self.state.lock().unwrap().log_level.color();
        egui::TopBottomPanel::bottom("log-panel")
            .frame(egui::Frame {
                fill: log_color,
                ..Default::default()
            })
            .show(context, |ui| {
                ui.with_layout(egui::Layout::top_down(egui::Align::Center), |ui| {
                    ui.add_space(5.0);
                    ui.label(
                        egui::RichText::new(self.state.lock().unwrap().log_message.clone())
                            .color(Color32::LIGHT_GRAY),
                    );
                    ui.add_space(3.0);
                });
            });
        egui::CentralPanel::default().show(context, |ui| {
            ui.add(egui::Image::new(egui::include_image!("assets/logo.png")).max_width(200.0));
            ui.add_space(20.0);
            egui::Grid::new("grid")
                .num_columns(2)
                .striped(true)
                .min_col_width(200.0)
                .show(ui, |ui| {
                    ui.label("Object name:");
                    ui.with_layout(egui::Layout::right_to_left(egui::Align::Min), |ui| {
                        if ui.button("USE CURRENT TIME").clicked() {
                            self.state.lock().unwrap().reset_object_name();
                        }
                        ui.with_layout(egui::Layout::top_down_justified(egui::Align::Min), |ui| {
                            ui.text_edit_singleline(&mut self.state.lock().unwrap().object_name);
                        });
                    });
                    ui.end_row();
                    ui.label("Selected camera:");
                    ui.with_layout(egui::Layout::left_to_right(egui::Align::Min), |ui| {
                        let all_cameras = self.state.lock().unwrap().all_cameras.clone();
                        let (text, label) = match &self.state.lock().unwrap().selected_camera {
                            Some(index) => {
                                (all_cameras.get(&index).unwrap().human_name(), String::new())
                            }
                            None => ("None".to_string(), "Select one!".to_string()),
                        };
                        egui::ComboBox::from_label(label)
                            .selected_text(text)
                            .show_ui(ui, |ui| {
                                for (index, info) in all_cameras {
                                    ui.selectable_value(
                                        &mut self.state.lock().unwrap().selected_camera,
                                        Some(index),
                                        info.human_name(),
                                    );
                                }
                            });
                        ui.with_layout(egui::Layout::right_to_left(egui::Align::Min), |ui| {
                            if ui.button("REFRESH").clicked() {
                                self.state.lock().unwrap().refresh_clicked = true;
                            }
                            if self.state.lock().unwrap().selected_camera.is_some() {
                                if ui.button("TEST").clicked() {
                                    self.state.lock().unwrap().test_clicked = true;
                                }
                            }
                        });
                    });
                    ui.end_row();
                    ui.label("Number of photos:");
                    ui.with_layout(egui::Layout::top_down_justified(egui::Align::Min), |ui| {
                        ui.add(egui::DragValue::new(
                            &mut self.state.lock().unwrap().num_photos,
                        ));
                    });
                    ui.end_row();
                    ui.label("Number of revolutions:");
                    ui.with_layout(egui::Layout::right_to_left(egui::Align::Min), |ui| {
                        ui.horizontal(|ui| {
                            ui.selectable_value(
                                &mut self.state.lock().unwrap().spiral_pattern,
                                true,
                                "SPIRAL",
                            );
                            ui.selectable_value(
                                &mut self.state.lock().unwrap().spiral_pattern,
                                false,
                                "CIRCLES",
                            );
                        });
                        ui.with_layout(egui::Layout::top_down_justified(egui::Align::Min), |ui| {
                            ui.add(egui::DragValue::new(
                                &mut self.state.lock().unwrap().num_revolutions,
                            ));
                        });
                    });
                    ui.end_row();
                    ui.label("Arm speed:");
                    ui.with_layout(egui::Layout::left_to_right(egui::Align::Min), |ui| {
                        ui.add(
                            egui::Slider::new(&mut self.state.lock().unwrap().arm_speed, 10..=200)
                                .suffix("%"),
                        );
                        ui.horizontal(|ui| {
                            ui.selectable_value(
                                &mut self.state.lock().unwrap().invert_arm,
                                false,
                                "DEFAULT",
                            );
                            ui.selectable_value(
                                &mut self.state.lock().unwrap().invert_arm,
                                true,
                                "REVERSED",
                            );
                        });
                    });
                    ui.end_row();
                    ui.label("Base speed:");
                    ui.with_layout(egui::Layout::left_to_right(egui::Align::Min), |ui| {
                        ui.add(
                            egui::Slider::new(&mut self.state.lock().unwrap().base_speed, 10..=200)
                                .suffix("%"),
                        );
                        ui.horizontal(|ui| {
                            ui.selectable_value(
                                &mut self.state.lock().unwrap().invert_base,
                                false,
                                "DEFAULT",
                            );
                            ui.selectable_value(
                                &mut self.state.lock().unwrap().invert_base,
                                true,
                                "REVERSED",
                            );
                        });
                    });
                    ui.end_row();
                    ui.label("Arm start height:");
                    ui.with_layout(egui::Layout::left_to_right(egui::Align::Min), |ui| {
                        ui.add(
                            egui::Slider::new(
                                &mut self.state.lock().unwrap().start_height,
                                0..=100,
                            )
                            .suffix("%"),
                        );
                    });
                    ui.end_row();
                    ui.label("Photos per position (delay):");
                    ui.with_layout(egui::Layout::left_to_right(egui::Align::Min), |ui| {
                        ui.add(egui::Slider::new(
                            &mut self.state.lock().unwrap().photos_per_position,
                            1..=10,
                        ));
                        ui.add(
                            egui::Slider::new(
                                &mut self.state.lock().unwrap().shutter_delay,
                                0..=3000,
                            )
                            .suffix("ms"),
                        );
                    });
                    ui.end_row();
                    ui.label("Save directory:");
                    ui.with_layout(egui::Layout::right_to_left(egui::Align::Min), |ui| {
                        let mut state = self.state.lock().unwrap();
                        if ui.button("BROWSE").clicked() {
                            state.save_directory_dialog.pick_directory();
                        }
                        ui.with_layout(egui::Layout::top_down_justified(egui::Align::Min), |ui| {
                            ui.text_edit_singleline(&mut state.save_directory.to_string_lossy());
                        });
                        state.save_directory_dialog.update(context);
                        if let Some(path) = &state.save_directory_dialog.take_picked() {
                            state.save_directory = path.to_path_buf();
                        }
                    });
                    ui.end_row();
                });
            ui.with_layout(egui::Layout::bottom_up(egui::Align::Center), |ui| {
                ui.add_space(10.0);
                let progress = self.state.lock().unwrap().progress;
                ui.add(egui::ProgressBar::new(progress).fill(
                    if progress == 0.0 || progress == 1.0 {
                        Color32::TRANSPARENT
                    } else {
                        Color32::from_rgb(0x00, 0x5C, 0x80) // BLUE
                    },
                ));
                ui.add_space(10.0);
                let mut enabled: bool = true;
                let capture_text = match self.state.lock().unwrap().capture_state {
                    CaptureState::Idle => "START SCAN",
                    CaptureState::InProgress => "PAUSE",
                    CaptureState::Paused => "RESUME",
                    CaptureState::Stopped => {
                        enabled = false;
                        "START SCAN"
                    }
                };
                ui.add_enabled_ui(enabled, |ui| {
                    if ui.button(capture_text).clicked() {
                        println!("CLICK");
                        self.state.lock().unwrap().capture_clicked = true;
                    }
                });
                ui.add_space(10.0);
                ui.separator();
                ui.add_space(20.0);
            });
        });
    }
}

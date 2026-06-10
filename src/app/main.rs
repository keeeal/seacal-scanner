#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]

mod camera;
mod interface;
mod main_thread;
mod message;
mod read_thread;
mod write_thread;

use std::collections::HashMap;
use std::path::PathBuf;
use std::sync::{Arc, Mutex};
use std::thread;
use std::time::{Duration, Instant};

use chrono::Local;
use directories::UserDirs;
use egui_file_dialog::FileDialog;

#[derive(Debug, Clone)]
pub enum LogLevel {
    Error,
    Warning,
    Info,
    Success,
}

#[derive(Debug, Clone, PartialEq)]
pub enum CaptureState {
    Idle,
    InProgress,
    Paused,
    Stopped,
}

pub struct State {
    pub object_name: String,
    pub all_cameras: HashMap<camera::Index, camera::Info>,
    pub selected_camera: Option<camera::Index>,
    pub test_clicked: bool,
    pub refresh_clicked: bool,
    pub num_photos: u32,
    pub num_revolutions: u32,
    pub spiral_pattern: bool,
    pub arm_speed: u8,
    pub invert_arm: bool,
    pub base_speed: u8,
    pub invert_base: bool,
    pub start_height: u8,
    pub photos_per_position: u32,
    pub shutter_delay: u32,
    pub save_directory_dialog: FileDialog,
    pub save_directory: PathBuf,
    pub capture_clicked: bool,
    pub capture_state: CaptureState,
    pub progress: f32,
    pub log_message: String,
    pub log_level: LogLevel,
    pub log_time: Option<Instant>,
}

impl Default for State {
    fn default() -> Self {
        Self {
            object_name: Local::now().format("%Y-%m-%d-%H-%M-%S").to_string(),
            all_cameras: camera::list().unwrap(),
            selected_camera: None,
            test_clicked: false,
            refresh_clicked: false,
            num_photos: 100,
            num_revolutions: 5,
            spiral_pattern: false,
            arm_speed: 100,
            invert_arm: false,
            base_speed: 100,
            invert_base: false,
            start_height: 0,
            photos_per_position: 1,
            shutter_delay: 0,
            save_directory_dialog: FileDialog::new(),
            save_directory: UserDirs::new()
                .unwrap()
                .picture_dir()
                .unwrap()
                .to_path_buf(),
            capture_clicked: false,
            capture_state: CaptureState::Idle,
            progress: 0.0,
            log_message: String::new(),
            log_level: LogLevel::Info,
            log_time: None,
        }
    }
}

impl State {
    pub fn log(&mut self, level: LogLevel, message: String) {
        println!("[{}] {:?}: {}", Local::now(), level, message);
        self.log_message = message;
        self.log_level = level;
        self.log_time = Some(Instant::now());
    }

    pub fn log_if_quiet_for(&mut self, duration: Duration, level: LogLevel, message: String) {
        if self.log_time.is_none() || duration < Instant::now() - self.log_time.unwrap() {
            self.log(level, message);
        }
    }

    pub fn reset_object_name(&mut self) {
        self.object_name = Local::now().format("%Y-%m-%d-%H-%M-%S").to_string();
    }
}

#[derive(Default)]
struct App {
    state: Arc<Mutex<State>>,
}

impl App {
    fn new(creation_context: &eframe::CreationContext<'_>) -> Self {
        egui_extras::install_image_loaders(&creation_context.egui_ctx);
        interface::initialize(creation_context);

        let app = Self::default();
        let state = app.state.clone();
        let context = creation_context.egui_ctx.clone();
        thread::spawn(|| main_thread::spawn(state, context));
        app
    }
}

fn main() -> eframe::Result {
    eframe::run_native(
        "",
        interface::options(),
        Box::new(|creation_context| Ok(Box::new(App::new(creation_context)))),
    )
}

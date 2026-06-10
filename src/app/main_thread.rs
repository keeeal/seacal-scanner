use std::collections::VecDeque;
use std::env::consts::OS;
use std::path::Path;
use std::sync::mpsc::channel;
use std::sync::mpsc::TryRecvError;
use std::sync::{Arc, Mutex};
use std::thread;
use std::time::Duration;

use eframe::egui;

use crate::camera;
use crate::camera::Camera;
use crate::message::Message;
use crate::{read_thread, write_thread};
use crate::{CaptureState, LogLevel, State};

const SERIAL_BAUD: u32 = 115200;

// #[derive(Debug, Clone)]
struct Position {
    index: u32,
    base: f64,
    arm: f64,
    photo: bool,
}

impl Position {
    fn to_scanner_coordinates(&self) -> (u32, u32) {
        ((self.base * 1024.) as u32, (self.arm * 1024.) as u32)
    }

    fn to_degrees(&self) -> (f64, f64) {
        ((self.base * 360.) % 360., (self.arm * 150.) - 60.)
    }
}

fn generate_positions(
    num_photos: u32,
    num_revolutions: f64,
    spiral_pattern: bool,
    start_height: f64,
    stop_height: f64,
) -> Vec<Position> {
    if num_photos == 0 {
        return Vec::new();
    }
    let mut positions = Vec::new();
    for index in 0..num_photos {
        let mut fraction = (index + 1) as f64 / num_photos as f64;
        let base_position = fraction * num_revolutions;
        if !spiral_pattern {
            fraction = base_position.floor() / num_revolutions;
        }
        let arm_position = fraction * (stop_height - start_height) + start_height;
        positions.push(Position {
            index,
            base: base_position,
            arm: arm_position,
            photo: true,
        });
    }
    positions.push(Position {
        index: num_photos,
        base: positions.last().unwrap().base,
        arm: 0.,
        photo: false,
    });
    positions
}

pub fn spawn(state: Arc<Mutex<State>>, context: egui::Context) {
    let log = |level: LogLevel, message: String| {
        state.lock().unwrap().log(level, message);
        context.request_repaint();
    };
    let log_if_quiet_for = |duration: Duration, level: LogLevel, message: String| {
        state
            .lock()
            .unwrap()
            .log_if_quiet_for(duration, level, message);
        context.request_repaint();
    };

    let port_prefix = if OS == "windows" {
        "COM"
    } else if OS == "linux" {
        "/dev/ttyACM"
    } else {
        panic!("Unsupported OS");
    };

    let read_port = Arc::new(Mutex::new(None));
    let write_port = Arc::new(Mutex::new(None));
    let read_port_clone = read_port.clone();
    let write_port_clone = write_port.clone();
    let (read_sender, read_receiver) = channel::<Message>();
    let (write_sender, write_receiver) = channel::<Message>();
    thread::spawn(|| read_thread::spawn(read_port_clone, read_sender));
    thread::spawn(|| write_thread::spawn(write_port_clone, write_receiver));

    let mut last_arm_speed: u8 = 100;
    let mut last_base_speed: u8 = 100;
    let mut move_to = |coordinates: (u32, u32)| {
        let arm_speed = state.lock().unwrap().arm_speed;
        let base_speed = state.lock().unwrap().base_speed;
        if arm_speed != last_arm_speed || base_speed != last_base_speed {
            write_sender
                .send(Message::SetSpeed((base_speed, arm_speed)))
                .unwrap();
            last_arm_speed = arm_speed;
            last_base_speed = base_speed;
            println!("Set speed to ({}, {})", base_speed, arm_speed);
            thread::sleep(Duration::from_millis(100));
        }
        write_sender.send(Message::MoveTo(coordinates)).unwrap();
    };

    let mut camera: Option<Camera> = None;
    let mut position_queue: VecDeque<Position> = VecDeque::new();
    let mut object_directory: Option<String> = None;

    loop {
        if state.lock().unwrap().refresh_clicked {
            state.lock().unwrap().refresh_clicked = false;
            match camera::list() {
                Ok(cameras) => state.lock().unwrap().all_cameras = cameras,
                Err(error) => state
                    .lock()
                    .unwrap()
                    .log(LogLevel::Error, format!("{}", error)),
            }
        }
        if state.lock().unwrap().test_clicked {
            state.lock().unwrap().test_clicked = false;
            let selected_camera = state.lock().unwrap().selected_camera.clone();
            camera = match camera::setup(selected_camera) {
                Ok(camera) => Some(camera),
                Err(error) => {
                    log(LogLevel::Error, format!("{}", error));
                    continue;
                }
            };
            if let Some(ref mut camera) = camera {
                let save_directory = state.lock().unwrap().save_directory.clone();
                let path = format!("{}/TEST.jpg", save_directory.to_str().unwrap());
                match camera::save_photo(camera, Path::new(&path)) {
                    Ok(buffer) => log(
                        LogLevel::Success,
                        format!("Saved to {} ({})", path, buffer.resolution()),
                    ),
                    Err(error) => log(LogLevel::Error, format!("{}", error)),
                }
            }
        }
        if read_port.lock().unwrap().is_none() || write_port.lock().unwrap().is_none() {
            *read_port.lock().unwrap() = None;
            *write_port.lock().unwrap() = None;

            log_if_quiet_for(
                Duration::from_secs(2),
                LogLevel::Warning,
                "Searching for device".to_string(),
            );
            let ports = serialport::available_ports().unwrap_or_default();
            for info in ports {
                if !info.port_name.starts_with(port_prefix) {
                    continue;
                }
                let port = match serialport::new(&info.port_name, SERIAL_BAUD)
                    .dtr_on_open(true)
                    .timeout(Duration::from_millis(10))
                    .open()
                {
                    Ok(port) => port,
                    Err(_) => continue,
                };
                match port.clear(serialport::ClearBuffer::All) {
                    Ok(()) => {}
                    Err(_) => {
                        continue;
                    }
                }
                *read_port.lock().unwrap() = Some(port.try_clone().unwrap());
                *write_port.lock().unwrap() = Some(port);

                // Ping the device and wait for a pong response
                write_sender.send(Message::Ping).unwrap();
                match read_receiver.recv_timeout(Duration::from_secs(1)) {
                    Ok(Message::Pong) => {
                        log(LogLevel::Success, "Connected".to_string());
                        continue;
                    }
                    _ => {
                        *read_port.lock().unwrap() = None;
                        *write_port.lock().unwrap() = None;
                        continue;
                    }
                }
            }
            thread::sleep(Duration::from_millis(100));
        } else {
            match read_receiver.try_recv() {
                Ok(Message::MoveComplete(reported_coordinates)) => {
                    println!("Scanner is at {:?}", reported_coordinates);
                    if position_queue.front().is_none() {
                        log(
                            LogLevel::Warning,
                            format!("Unexpected position: {:?}", reported_coordinates),
                        );
                        continue;
                    }
                    let current_position = position_queue.front().unwrap();
                    let current_coordinates = current_position.to_scanner_coordinates();
                    if reported_coordinates != current_coordinates {
                        log(
                            LogLevel::Warning,
                            format!(
                                "Expected position {:?}, got {:?}",
                                current_coordinates, reported_coordinates
                            ),
                        );
                        if state.lock().unwrap().capture_state != CaptureState::Paused {
                            move_to(current_coordinates);
                        }
                        continue;
                    }
                    if current_position.photo {
                        let (base_degrees, arm_degrees) = current_position.to_degrees();
                        if let Some(ref mut camera) = camera {
                            let save_directory = state.lock().unwrap().save_directory.clone();
                            let object_name = state.lock().unwrap().object_name.clone();
                            let photos_per_position =
                                state.lock().unwrap().photos_per_position.clone();
                            let shutter_delay = state.lock().unwrap().shutter_delay.clone();
                            if object_directory.is_none() {
                                object_directory = Some(
                                    format!("{}/{}", save_directory.to_str().unwrap(), object_name)
                                        .to_string(),
                                )
                            }
                            for index in 0..photos_per_position {
                                thread::sleep(Duration::from_millis(shutter_delay as u64));
                                let path = format!(
                                    "{}/{}_{:.1}deg_{:.1}deg{}.jpg",
                                    object_directory.as_ref().unwrap(),
                                    current_position.index,
                                    base_degrees,
                                    arm_degrees,
                                    if photos_per_position > 1 {
                                        format!(".{}", index + 1)
                                    } else {
                                        "".to_string()
                                    }
                                );
                                match camera::save_photo(camera, Path::new(&path)) {
                                    Ok(buffer) => log(
                                        LogLevel::Success,
                                        format!("Saved to {} ({})", path, buffer.resolution()),
                                    ),
                                    Err(error) => log(LogLevel::Error, format!("{}", error)),
                                }
                            }
                        }
                    }
                    state.lock().unwrap().progress = (current_position.index + 1) as f32
                        / (position_queue.back().unwrap().index + 1) as f32;
                    position_queue.pop_front();
                    if let Some(next_position) = position_queue.front() {
                        if state.lock().unwrap().capture_state != CaptureState::Paused {
                            move_to(next_position.to_scanner_coordinates());
                        }
                    } else {
                        write_sender.send(Message::DisableSteppers).unwrap();
                        object_directory = None;
                        state.lock().unwrap().capture_state = CaptureState::Idle;
                    }
                    context.request_repaint();
                }
                Ok(Message::StartPressed) => {
                    state.lock().unwrap().capture_clicked = true;
                }
                Ok(Message::StopPressed) => {
                    log(LogLevel::Error, "Emergency stop activated".to_string());
                    position_queue.clear();
                    state.lock().unwrap().capture_state = CaptureState::Stopped;
                    state.lock().unwrap().progress = 0.;
                    context.request_repaint();
                }
                Ok(Message::StopReleased) => {
                    log(LogLevel::Info, "Emergency stop released".to_string());
                    position_queue.clear();
                    state.lock().unwrap().capture_state = CaptureState::Idle;
                    state.lock().unwrap().progress = 0.;
                    context.request_repaint();
                }
                Ok(Message::HomingInProgress) => {
                    log(LogLevel::Info, "Homing in progress".to_string())
                }
                Ok(Message::HomingError) => log(LogLevel::Error, "Homing Error".to_string()),
                Ok(Message::UnexpectedMsg(discriminant)) => log(
                    LogLevel::Warning,
                    format!("[CTRL] Unexpected message: {:X}", discriminant),
                ),
                Ok(message) => log(
                    LogLevel::Warning,
                    format!("[APP] Unexpected message: {:?}", message),
                ),
                Err(TryRecvError::Disconnected) => {
                    *read_port.lock().unwrap() = None;
                    *write_port.lock().unwrap() = None;
                    continue;
                }
                Err(TryRecvError::Empty) => {}
            }
            if state.lock().unwrap().capture_clicked {
                state.lock().unwrap().capture_clicked = false;
                let capture_state = state.lock().unwrap().capture_state.clone();
                let selected_camera = state.lock().unwrap().selected_camera.clone();
                let num_photos = state.lock().unwrap().num_photos.clone();
                let num_revolutions = state.lock().unwrap().num_revolutions.clone();
                let spiral_pattern = state.lock().unwrap().spiral_pattern.clone();
                let start_height = state.lock().unwrap().start_height.clone();

                match capture_state {
                    CaptureState::Idle => {
                        position_queue.clear();
                        camera = match camera::setup(selected_camera) {
                            Ok(camera) => Some(camera),
                            Err(error) => {
                                log(LogLevel::Error, format!("{}", error));
                                continue;
                            }
                        };

                        println!("Camera set");

                        position_queue.extend(generate_positions(
                            num_photos,
                            num_revolutions as f64,
                            spiral_pattern,
                            start_height as f64 / 100.,
                            1.0, // Stop height is not implemented in UI
                        ));
                        thread::sleep(Duration::from_millis(100));
                        if let Some(next_position) = position_queue.front() {
                            state.lock().unwrap().capture_state = CaptureState::InProgress;
                            write_sender.send(Message::ZeroBase).unwrap();
                            move_to(next_position.to_scanner_coordinates());
                        }
                    }
                    CaptureState::InProgress => {
                        state.lock().unwrap().capture_state = CaptureState::Paused;
                    }
                    CaptureState::Paused => {
                        if let Some(next_position) = position_queue.front() {
                            state.lock().unwrap().capture_state = CaptureState::InProgress;
                            move_to(next_position.to_scanner_coordinates());
                        } else {
                            state.lock().unwrap().capture_state = CaptureState::Idle;
                        }
                    }
                    CaptureState::Stopped => {}
                }
                context.request_repaint();
            }
        }
    }
}

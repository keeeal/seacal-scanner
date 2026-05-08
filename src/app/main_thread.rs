use std::collections::VecDeque;
use std::env::consts::OS;
use std::fmt::{Display, Formatter};
use std::fs::{create_dir_all, File};
use std::io::{Error as IOError, Write};
use std::path::Path;
use std::sync::mpsc::channel;
use std::sync::mpsc::RecvTimeoutError;
use std::sync::{Arc, Mutex};
use std::thread;
use std::time::Duration;

use eframe::egui;
use nokhwa::pixel_format::RgbFormat;
use nokhwa::utils::{ApiBackend, RequestedFormat, RequestedFormatType};
use nokhwa::{Buffer, Camera, NokhwaError};

use crate::interface::{LogLevel, State};
use crate::message::Message;
use crate::read_thread;
use crate::write_thread;

#[derive(Debug)]
enum CameraError {
    NoCameraSelected,
    IOError(IOError),
    NokhwaError(NokhwaError),
}

impl From<IOError> for CameraError {
    fn from(error: IOError) -> CameraError {
        CameraError::IOError(error)
    }
}

impl From<NokhwaError> for CameraError {
    fn from(error: NokhwaError) -> CameraError {
        CameraError::NokhwaError(error)
    }
}

fn setup_camera(state: &Arc<Mutex<State>>) -> Result<Camera, CameraError> {
    if state.lock().unwrap().selected_camera.is_none() {
        return Err(CameraError::NoCameraSelected);
    }
    let camera = Camera::new(
        state.lock().unwrap().selected_camera.clone().unwrap(),
        RequestedFormat::new::<RgbFormat>(RequestedFormatType::AbsoluteHighestResolution),
    )?;
    Ok(camera)
}

fn save_photo(camera: &mut Camera, path: &Path) -> Result<Buffer, CameraError> {
    camera.open_stream()?;
    let frame = camera.frame()?;
    camera.stop_stream()?;

    if let Some(parent) = path.parent() {
        create_dir_all(parent)?;
    }
    let mut file = File::create(path)?;
    file.write_all(&frame.buffer())?;
    Ok(frame)
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

    let baud_rate = 2e6 as u32;
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

    let mut camera: Option<Camera> = None;
    let mut position_queue: VecDeque<(u32, (u32, u32))> = VecDeque::new();

    loop {
        if state.lock().unwrap().refresh_clicked {
            state.lock().unwrap().refresh_clicked = false;
            state.lock().unwrap().all_cameras = nokhwa::query(ApiBackend::Auto)
                .unwrap()
                .iter()
                .map(|info| (info.index().clone(), info.clone()))
                .collect();
        }
        if state.lock().unwrap().test_clicked {
            state.lock().unwrap().test_clicked = false;
            camera = match setup_camera(&state) {
                Ok(camera) => Some(camera),
                Err(error) => {
                    log(LogLevel::Error, format!("{:?}", error));
                    continue;
                }
            };
            if let Some(ref mut camera) = camera {
                let save_directory = state.lock().unwrap().save_directory.clone();
                let path = format!("{}/TEST.jpg", save_directory.to_str().unwrap());
                match save_photo(camera, Path::new(&path)) {
                    Ok(buffer) => log(
                        LogLevel::Success,
                        format!("Saved frame: {}", buffer.resolution()),
                    ),
                    Err(error) => log(LogLevel::Error, format!("{:?}", error)),
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
                let port = match serialport::new(&info.port_name, baud_rate).open() {
                    Ok(port) => port,
                    Err(_) => continue,
                };
                *read_port.lock().unwrap() = Some(port.try_clone().unwrap());
                *write_port.lock().unwrap() = Some(port);
                thread::sleep(Duration::from_millis(100));

                // Ping the device and wait for a pong response
                write_sender.send(Message::Ping).unwrap();
                match read_receiver.recv_timeout(Duration::from_millis(100)) {
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
            match read_receiver.recv_timeout(Duration::from_millis(100)) {
                Ok(Message::MoveComplete(position)) => {
                    println!("Scanner is at {:?}", position);
                    let index;
                    if let Some(&(next_index, next_position)) = position_queue.front() {
                        if position != next_position {
                            log(
                                LogLevel::Warning,
                                format!(
                                    "Expected position {:?}, got {:?}",
                                    next_position, position
                                ),
                            );
                            write_sender.send(Message::MoveTo(next_position)).unwrap();
                            continue;
                        }
                        index = next_index;
                    } else {
                        log(
                            LogLevel::Warning,
                            format!("Unexpected position: {:?}", position),
                        );
                        continue;
                    }

                    if let Some(ref mut camera) = camera {
                        let save_directory = state.lock().unwrap().save_directory.clone();
                        let object_name = state.lock().unwrap().object_name.clone();
                        let path = format!(
                            "{}/{}/{}-({:.1}deg,{:.1}deg).jpg",
                            save_directory.to_str().unwrap(),
                            object_name,
                            index,
                            position.0 as f64 * (360. / 1024.) % 360.,
                            position.1 as f64 * (150. / 1024.) - 60.,
                        );
                        match save_photo(camera, Path::new(&path)) {
                            Ok(buffer) => log(
                                LogLevel::Success,
                                format!("Saved frame: {}", buffer.resolution()),
                            ),
                            Err(error) => log(LogLevel::Error, format!("{:?}", error)),
                        }
                    }
                    position_queue.pop_front();
                    if let Some(&(_, next_position)) = position_queue.front() {
                        write_sender.send(Message::MoveTo(next_position)).unwrap();
                    }
                }
                Ok(Message::UnexpectedMsg(discriminant)) => log(
                    LogLevel::Warning,
                    format!("[CTRL] Unexpected message: {:X}", discriminant),
                ),
                Ok(message) => log(
                    LogLevel::Warning,
                    format!("[APP] Unexpected message: {:?}", message),
                ),
                Err(RecvTimeoutError::Timeout) => {}
                Err(RecvTimeoutError::Disconnected) => {
                    *read_port.lock().unwrap() = None;
                    *write_port.lock().unwrap() = None;
                    continue;
                }
            }
            if state.lock().unwrap().capture_clicked {
                state.lock().unwrap().capture_clicked = false;
                position_queue.clear();
                camera = match setup_camera(&state) {
                    Ok(camera) => Some(camera),
                    Err(error) => {
                        log(LogLevel::Error, format!("{:?}", error));
                        continue;
                    }
                };

                let num_photos = state.lock().unwrap().num_photos;
                let num_revolutions = state.lock().unwrap().num_revolutions as f64;
                let spiral_pattern = state.lock().unwrap().spiral_pattern;
                let start_height = state.lock().unwrap().start_height as f64 / 100.;
                let stop_height = 1.0;

                for index in 0..num_photos {
                    let mut fraction = (index + 1) as f64 / num_photos as f64;
                    let base_position = fraction * num_revolutions;
                    if !spiral_pattern {
                        fraction = base_position.floor() / num_revolutions;
                    }
                    let arm_position = fraction * (stop_height - start_height) + start_height;
                    position_queue.push_back((
                        index,
                        (
                            (base_position * 1024.) as u32,
                            (arm_position * 1024.) as u32,
                        ),
                    ));
                }
                if let Some(&(_, next_position)) = position_queue.front() {
                    write_sender.send(Message::ZeroBase).unwrap();
                    write_sender.send(Message::MoveTo(next_position)).unwrap();
                }
            }
            thread::sleep(Duration::from_millis(20));
        }
    }
}

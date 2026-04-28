use std::env::consts::OS;
use std::fs::OpenOptions;
use std::io::Write;
use std::sync::mpsc::channel;
use std::sync::mpsc::RecvTimeoutError;
use std::sync::{Arc, Mutex};
use std::thread;
use std::time::Duration;

use eframe::egui;
use nokhwa::pixel_format::RgbFormat;
use nokhwa::utils::{ApiBackend, RequestedFormat, RequestedFormatType};
use nokhwa::Camera;

use crate::interface::{LogLevel, State};
use crate::message::Message;
use crate::read_thread;
use crate::write_thread;

pub fn spawn(state: Arc<Mutex<State>>, context: egui::Context) {
    let log = |level: LogLevel, message: String| {
        println!("{:?}: {}", level, message);
        let mut inner = state.lock().unwrap();
        inner.log_message = message;
        inner.log_level = level;
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

    let mut photo_index = 0;

    loop {
        if state.lock().unwrap().refresh_clicked {
            let mut inner = state.lock().unwrap();
            inner.all_cameras = nokhwa::query(ApiBackend::Auto)
                .unwrap()
                .iter()
                .map(|info| (info.index().clone(), info.clone()))
                .collect();
            inner.refresh_clicked = false;
        }
        // if read_port.lock().unwrap().is_none() || write_port.lock().unwrap().is_none() {
        if false {
            *read_port.lock().unwrap() = None;
            *write_port.lock().unwrap() = None;

            log(LogLevel::Warning, "Searching for device".to_string());
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
            // match read_receiver.recv_timeout(Duration::from_millis(100)) {
            //     Ok(message) => log(
            //         LogLevel::Warning,
            //         format!("Unexpected message: {:?}", message),
            //     ),
            //     Err(RecvTimeoutError::Timeout) => {}
            //     Err(RecvTimeoutError::Disconnected) => {
            //         *read_port.lock().unwrap() = None;
            //         *write_port.lock().unwrap() = None;
            //         continue;
            //     }
            // }
            if state.lock().unwrap().capture_clicked {
                if state.lock().unwrap().selected_camera.is_none() {
                    log(LogLevel::Warning, "Please select a camera...".to_string());
                    state.lock().unwrap().capture_clicked = false;
                    continue;
                }
                let maybe_camera = Camera::new(
                    state.lock().unwrap().selected_camera.clone().unwrap(),
                    RequestedFormat::new::<RgbFormat>(
                        RequestedFormatType::AbsoluteHighestResolution,
                    ),
                );
                let mut camera = match maybe_camera {
                    Ok(camera) => camera,
                    Err(error) => {
                        log(LogLevel::Error, format!("{:?}", error));
                        state.lock().unwrap().capture_clicked = false;
                        continue;
                    }
                };
                match camera.open_stream() {
                    Ok(_) => {}
                    Err(error) => {
                        log(LogLevel::Error, format!("{:?}", error));
                        state.lock().unwrap().capture_clicked = false;
                        continue;
                    }
                }
                let frame = match camera.frame() {
                    Ok(frame) => frame,
                    Err(error) => {
                        log(LogLevel::Error, format!("{:?}", error));
                        state.lock().unwrap().capture_clicked = false;
                        continue;
                    }
                };
                log(
                    LogLevel::Success,
                    format!("Captured frame: {}", frame.resolution()),
                );
                {
                    let inner = state.lock().unwrap();
                    let mut file = OpenOptions::new()
                        .create(true)
                        .write(true)
                        .open(format!(
                            "{}/{}-{}.jpg",
                            inner.save_directory.to_str().unwrap(),
                            inner.object_name,
                            photo_index,
                        ))
                        .unwrap();
                    file.write_all(&frame.buffer()).unwrap();
                }
                state.lock().unwrap().capture_clicked = false;
            }
            thread::sleep(Duration::from_millis(20));
        }
    }
}

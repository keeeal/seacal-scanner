use std::sync::mpsc::{Receiver, RecvTimeoutError};
use std::sync::{Arc, Mutex};
use std::thread;
use std::time::Duration;

use serialport::SerialPort;

use crate::message::Message;

pub fn spawn(port: Arc<Mutex<Option<Box<dyn SerialPort>>>>, receiver: Receiver<Message>) {
    loop {
        if let Some(port) = port.lock().unwrap().as_mut() {
            match receiver.recv_timeout(Duration::from_millis(10)) {
                Ok(message) => {
                    let serialized = rmp_serde::to_vec(&message).unwrap();
                    if port.write_all(&serialized).is_err() {
                        continue;
                    }
                }
                Err(RecvTimeoutError::Timeout) => {}
                Err(error) => {
                    eprintln!("write thread error: {:?}", error);
                }
            }
        }
        thread::sleep(Duration::from_millis(10));
    }
}

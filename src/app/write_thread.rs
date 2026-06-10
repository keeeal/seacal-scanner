use std::io::Write;
use std::sync::mpsc::Receiver;
use std::sync::{Arc, Mutex};

use serialport::SerialPort;

use crate::message::Message;

pub fn spawn(port: Arc<Mutex<Option<Box<dyn SerialPort>>>>, receiver: Receiver<Message>) {
    loop {
        match receiver.recv() {
            Ok(message) => {
                if let Some(port) = port.lock().unwrap().as_mut() {
                    let serialized = rmp_serde::to_vec(&message).unwrap();
                    port.write_all(&serialized).unwrap();
                    port.flush().unwrap();
                }
            }
            Err(error) => panic!("{}", error),
        }
    }
}

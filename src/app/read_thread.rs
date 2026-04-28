use std::collections::VecDeque;
use std::io::{Error, ErrorKind};
use std::sync::mpsc::Sender;
use std::sync::{Arc, Mutex};
use std::thread;
use std::time::Duration;

use serialport::{ClearBuffer, SerialPort};

use crate::message::Message;

pub fn spawn(port: Arc<Mutex<Option<Box<dyn SerialPort>>>>, sender: Sender<Message>) {
    let mut port_name = None;
    let mut read_result: Result<usize, Error> = Ok(0);
    let mut serial_buffer = [0; 64];
    let mut message_buffer = VecDeque::new();
    let mut copy_buffer = VecDeque::new();

    loop {
        if let Some(port) = port.lock().unwrap().as_mut() {
            if port.name() != port_name {
                port.clear(ClearBuffer::Input).unwrap();
                port_name = port.name();
            }
            read_result = port.read(&mut serial_buffer);
        } else {
            port_name = None;
        }
        match read_result {
            Ok(num_bytes) if num_bytes > 0 => {
                // Append the new data to both message and copy buffers
                // The copy buffer is used to restore the message buffer if
                // the message is incomplete
                message_buffer.extend(serial_buffer.iter().take(num_bytes));
                copy_buffer.extend(serial_buffer.iter().take(num_bytes));
            }
            Err(ref error) if error.kind() != ErrorKind::TimedOut => {
                println!("Error reading from serial port: {:?}", error);
                *port.lock().unwrap() = None;
                read_result = Ok(0);
            }
            _ => {
                // No data available, sleep to avoid busy waiting
                thread::sleep(Duration::from_millis(10));
            }
        }
        if message_buffer.is_empty() {
            continue;
        }
        match rmp_serde::from_read(&mut message_buffer) {
            Ok(message) => {
                sender.send(message).unwrap();
            }
            Err(
                rmp_serde::decode::Error::InvalidMarkerRead(error)
                | rmp_serde::decode::Error::InvalidDataRead(error),
            ) if error.kind() == ErrorKind::UnexpectedEof => {
                // Incomplete payload, restore buffer and continue reading
                message_buffer = copy_buffer.clone();
                continue;
            }
            Err(error) => {
                panic!("Error reading message: {:?}", error);
            }
        }
        // Remove the processed message from the copy buffer
        copy_buffer.drain(..copy_buffer.len() - message_buffer.len());
    }
}

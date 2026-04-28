#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]

mod interface;
mod main_thread;
mod message;
mod read_thread;
mod write_thread;

use std::sync::{Arc, Mutex};
use std::thread;

#[derive(Default)]
struct App {
    state: Arc<Mutex<interface::State>>,
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

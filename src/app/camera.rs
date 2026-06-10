use std::collections::HashMap;
use std::fmt;
use std::fs;
use std::fs::File;
use std::io;
use std::io::Write;
use std::path::Path;

use nokhwa::pixel_format::RgbFormat;
use nokhwa::utils::{ApiBackend, RequestedFormat, RequestedFormatType};
use nokhwa::{Buffer, NokhwaError};

pub type Camera = nokhwa::Camera;
pub type Index = nokhwa::utils::CameraIndex;
pub type Info = nokhwa::utils::CameraInfo;

#[derive(Debug)]
#[allow(unused)]
pub enum Error {
    NoCameraSelected,
    IO(io::Error),
    Camera(NokhwaError),
}

impl From<io::Error> for Error {
    fn from(error: io::Error) -> Error {
        Error::IO(error)
    }
}

impl From<NokhwaError> for Error {
    fn from(error: NokhwaError) -> Error {
        Error::Camera(error)
    }
}

impl fmt::Display for Error {
    fn fmt(&self, formatter: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Error::NoCameraSelected => write!(formatter, "Please select a camera"),
            Error::IO(error) => write!(formatter, "{}", error),
            Error::Camera(error) => write!(formatter, "{}", error),
        }
    }
}

pub fn list() -> Result<HashMap<Index, Info>, Error> {
    let cameras = nokhwa::query(ApiBackend::Auto)?;
    Ok(cameras
        .iter()
        .map(|info| (info.index().clone(), info.clone()))
        .collect())
}

pub fn setup(selected_camera: Option<Index>) -> Result<Camera, Error> {
    if selected_camera.is_none() {
        return Err(Error::NoCameraSelected);
    }
    let camera = Camera::new(
        selected_camera.unwrap(),
        RequestedFormat::new::<RgbFormat>(RequestedFormatType::AbsoluteHighestResolution),
    )?;
    Ok(camera)
}

pub fn save_photo(camera: &mut Camera, path: &Path) -> Result<Buffer, Error> {
    camera.open_stream()?;
    let frame = camera.frame()?;
    camera.stop_stream()?;

    if let Some(parent) = path.parent() {
        fs::create_dir_all(parent)?;
    }
    let mut file = File::create(path)?;
    file.write_all(frame.buffer())?;
    Ok(frame)
}

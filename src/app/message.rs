use rmpv::Value::Binary;
use serde::ser::SerializeStruct;
use serde::{Deserialize, Deserializer, Serialize, Serializer};

#[derive(Debug, PartialEq, Clone)]
pub enum Message {
    Ping,
    Pong,
    Info(String),
    Warning(String),
    Error(String),
    Success(String),
    MoveTo((u8, u8)),
    MoveComplete,
}

impl Message {
    fn discriminant(&self) -> u8 {
        match self {
            // Handshake
            Self::Ping => 0x00,
            Self::Pong => 0x01,
            // Logging
            Self::Info(_) => 0x10,
            Self::Warning(_) => 0x11,
            Self::Error(_) => 0x12,
            Self::Success(_) => 0x13,
            // Control
            Self::MoveTo(_) => 0x20,
            Self::MoveComplete => 0x21,
        }
    }
}

impl TryFrom<u8> for Message {
    type Error = &'static str;
    fn try_from(discriminant: u8) -> Result<Self, <Message as TryFrom<u8>>::Error> {
        for message in [
            Self::Ping,
            Self::Pong,
            Self::Info(String::new()),
            Self::Warning(String::new()),
            Self::Error(String::new()),
            Self::Success(String::new()),
            Self::MoveTo((0, 0)),
            Self::MoveComplete,
        ] {
            if message.discriminant() == discriminant {
                return Ok(message);
            }
        }
        Err("Invalid discriminant")
    }
}

#[derive(Deserialize, Serialize)]
struct PackedMessage {
    discriminant: u8,
    payload: Vec<u8>,
}

impl From<Message> for PackedMessage {
    fn from(message: Message) -> Self {
        let discriminant = message.discriminant();
        match message {
            Message::Ping => Self {
                discriminant,
                payload: Vec::new(),
            },
            Message::Pong => Self {
                discriminant,
                payload: Vec::new(),
            },
            Message::Info(text) => Self {
                discriminant,
                payload: text.into_bytes(),
            },
            Message::Warning(text) => Self {
                discriminant,
                payload: text.into_bytes(),
            },
            Message::Error(text) => Self {
                discriminant,
                payload: text.into_bytes(),
            },
            Message::Success(text) => Self {
                discriminant,
                payload: text.into_bytes(),
            },
            Message::MoveTo((x, y)) => Self {
                discriminant,
                payload: vec![x, y],
            },
            Message::MoveComplete => Self {
                discriminant,
                payload: Vec::new(),
            },
        }
    }
}

impl TryFrom<PackedMessage> for Message {
    type Error = &'static str;
    fn try_from(packed: PackedMessage) -> Result<Self, <Message as TryFrom<u8>>::Error> {
        match Self::try_from(packed.discriminant)? {
            Self::Ping => Ok(Self::Ping),
            Self::Pong => Ok(Self::Pong),
            Self::Info(_) => Ok(Self::Info(String::from_utf8(packed.payload).unwrap())),
            Self::Warning(_) => Ok(Self::Warning(String::from_utf8(packed.payload).unwrap())),
            Self::Error(_) => Ok(Self::Error(String::from_utf8(packed.payload).unwrap())),
            Self::Success(_) => Ok(Self::Success(String::from_utf8(packed.payload).unwrap())),
            Self::MoveTo(_) => Ok(Self::MoveTo((packed.payload[0], packed.payload[1]))),
            Self::MoveComplete => Ok(Self::MoveComplete),
        }
    }
}

impl<'de> Deserialize<'de> for Message {
    fn deserialize<D>(deserializer: D) -> Result<Self, D::Error>
    where
        D: Deserializer<'de>,
    {
        let packed: PackedMessage = Deserialize::deserialize(deserializer)?;
        packed.try_into().map_err(serde::de::Error::custom)
    }
}

impl Serialize for Message {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        let packed: PackedMessage = (*self).clone().into();
        let mut state = serializer.serialize_struct("PackedMessage", 2)?;
        state.serialize_field("discriminant", &packed.discriminant)?;
        // Force serde to treat payload as binary data, not as an array
        let binary_payload = Binary(packed.payload);
        state.serialize_field("payload", &binary_payload)?;
        state.end()
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    // MessagePack array header
    fn arr(size: usize) -> u8 {
        0x90 + size as u8
    }

    // MessagePack binary header (for length 0..255 only!)
    fn bin() -> u8 {
        0xC4
    }

    #[test]
    fn test_ping() {
        let discriminant = Message::Ping.discriminant();
        let message = Message::Ping;
        let buffer = rmp_serde::to_vec(&message).unwrap();
        let expected_buffer = vec![arr(2), discriminant, bin(), 0];
        assert_eq!(buffer, expected_buffer);
        let deserialized: Message = rmp_serde::from_slice(&buffer).unwrap();
        assert_eq!(deserialized, message);
    }

    #[test]
    fn test_pong() {
        let discriminant = Message::Pong.discriminant();
        let message = Message::Pong;
        let buffer = rmp_serde::to_vec(&message).unwrap();
        let expected_buffer = vec![arr(2), discriminant, bin(), 0];
        assert_eq!(buffer, expected_buffer);
        let deserialized: Message = rmp_serde::from_slice(&buffer).unwrap();
        assert_eq!(deserialized, message);
    }

    #[test]
    fn test_info() {
        let discriminant = Message::Info(String::new()).discriminant();
        let text = "Hello, world!";
        let message = Message::Info(String::from(text));
        let buffer = rmp_serde::to_vec(&message).unwrap();
        let mut expected_buffer = vec![arr(2), discriminant, bin(), text.len() as u8];
        expected_buffer.extend(text.bytes());
        assert_eq!(buffer, expected_buffer);
        let deserialized: Message = rmp_serde::from_slice(&buffer).unwrap();
        assert_eq!(deserialized, message);
    }

    #[test]
    fn test_warning() {
        let discriminant = Message::Warning(String::new()).discriminant();
        let text = "Hello, world!";
        let message = Message::Warning(String::from(text));
        let buffer = rmp_serde::to_vec(&message).unwrap();
        let mut expected_buffer = vec![arr(2), discriminant, bin(), text.len() as u8];
        expected_buffer.extend(text.bytes());
        assert_eq!(buffer, expected_buffer);
        let deserialized: Message = rmp_serde::from_slice(&buffer).unwrap();
        assert_eq!(deserialized, message);
    }

    #[test]
    fn test_error() {
        let discriminant = Message::Error(String::new()).discriminant();
        let text = "Hello, world!";
        let message = Message::Error(String::from(text));
        let buffer = rmp_serde::to_vec(&message).unwrap();
        let mut expected_buffer = vec![arr(2), discriminant, bin(), text.len() as u8];
        expected_buffer.extend(text.bytes());
        assert_eq!(buffer, expected_buffer);
        let deserialized: Message = rmp_serde::from_slice(&buffer).unwrap();
        assert_eq!(deserialized, message);
    }

    #[test]
    fn test_success() {
        let discriminant = Message::Success(String::new()).discriminant();
        let text = "Hello, world!";
        let message = Message::Success(String::from(text));
        let buffer = rmp_serde::to_vec(&message).unwrap();
        let mut expected_buffer = vec![arr(2), discriminant, bin(), text.len() as u8];
        expected_buffer.extend(text.bytes());
        assert_eq!(buffer, expected_buffer);
        let deserialized: Message = rmp_serde::from_slice(&buffer).unwrap();
        assert_eq!(deserialized, message);
    }
}

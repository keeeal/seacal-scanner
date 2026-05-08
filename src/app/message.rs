use serde::ser::SerializeStruct;
use serde::{Deserialize, Deserializer, Serialize, Serializer};

#[derive(Debug, PartialEq, Clone)]
pub enum Message {
    Ping,
    Pong,
    SetSpeed((u32, u32)),
    MoveTo((u32, u32)),
    MoveComplete((u32, u32)),
    ZeroBase,
    StartPressed,
    StopPressed,
    UnexpectedMsg(u32),
}

impl Message {
    fn discriminant(&self) -> u8 {
        match self {
            Self::Ping => 0x00,
            Self::Pong => 0x01,
            Self::SetSpeed(_) => 0x10,
            Self::MoveTo(_) => 0x11,
            Self::MoveComplete(_) => 0x12,
            Self::ZeroBase => 0x13,
            Self::StartPressed => 0x20,
            Self::StopPressed => 0x21,
            Self::UnexpectedMsg(_) => 0x30,
        }
    }
}

impl TryFrom<u8> for Message {
    type Error = &'static str;
    fn try_from(discriminant: u8) -> Result<Self, <Message as TryFrom<u8>>::Error> {
        for message in [
            Self::Ping,
            Self::Pong,
            Self::SetSpeed((0, 0)),
            Self::MoveTo((0, 0)),
            Self::MoveComplete((0, 0)),
            Self::ZeroBase,
            Self::StartPressed,
            Self::StopPressed,
            Self::UnexpectedMsg(0),
        ] {
            if message.discriminant() == discriminant {
                return Ok(message);
            }
        }
        Err("Invalid discriminant")
    }
}

#[derive(Default, Deserialize, Serialize)]
struct PackedMessage {
    discriminant: u8,
    parameter_0: u32,
    parameter_1: u32,
}

impl From<Message> for PackedMessage {
    fn from(message: Message) -> Self {
        let discriminant = message.discriminant();
        match message {
            Message::Ping => Self {
                discriminant,
                ..Default::default()
            },
            Message::Pong => Self {
                discriminant,
                ..Default::default()
            },
            Message::SetSpeed((x, y)) => Self {
                discriminant,
                parameter_0: x,
                parameter_1: y,
            },
            Message::MoveTo((x, y)) => Self {
                discriminant,
                parameter_0: x,
                parameter_1: y,
            },
            Message::MoveComplete((x, y)) => Self {
                discriminant,
                parameter_0: x,
                parameter_1: y,
            },
            Message::ZeroBase => Self {
                discriminant,
                ..Default::default()
            },
            Message::StartPressed => Self {
                discriminant,
                ..Default::default()
            },
            Message::StopPressed => Self {
                discriminant,
                ..Default::default()
            },
            Message::UnexpectedMsg(x) => Self {
                discriminant,
                parameter_0: x,
                ..Default::default()
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
            Self::SetSpeed(_) => Ok(Self::MoveTo((packed.parameter_0, packed.parameter_1))),
            Self::MoveTo(_) => Ok(Self::MoveTo((packed.parameter_0, packed.parameter_1))),
            Self::MoveComplete(_) => {
                Ok(Self::MoveComplete((packed.parameter_0, packed.parameter_1)))
            }
            Self::ZeroBase => Ok(Self::ZeroBase),
            Self::StartPressed => Ok(Self::StartPressed),
            Self::StopPressed => Ok(Self::StopPressed),
            Self::UnexpectedMsg(_) => Ok(Self::UnexpectedMsg(packed.parameter_0)),
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
        state.serialize_field("parameter_0", &packed.parameter_0)?;
        state.serialize_field("parameter_1", &packed.parameter_1)?;
        state.end()
    }
}

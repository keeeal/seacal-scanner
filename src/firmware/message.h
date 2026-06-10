#pragma once

#include <MsgPack.h>

namespace message
{

// ==== MESSAGE ====

enum MessageType
{
    // Handshake
    Ping = 0x00,
    Pong = 0x01,

    // Control
    MoveTo = 0x10,
    MoveComplete = 0x11,
    ZeroBase = 0x12,
    DisableSteppers = 0x13,
    SetSpeed = 0x14,

    // Buttons
    StartPressed = 0x20,
    StopPressed = 0x21,
    StopReleased = 0x22,

    // Status
    UnexpectedMsg = 0x30,
    HomingInProgress = 0x31,
    HomingError = 0x32,
};

struct PackedMessage
{
    uint8_t discriminant;
    uint32_t parameter_0;
    uint32_t parameter_1;
};

// ==== SERIAL ====

std::optional<PackedMessage> serial_receive(std::vector<uint8_t> &buffer)
{
    while (Serial.available())
    {
        uint8_t byte = Serial.read();
        buffer.push_back(byte);
    }
    if (buffer.empty())
        return std::nullopt;

    MsgPack::Unpacker unpacker;
    unpacker.feed(buffer.data(), buffer.size());

    uint8_t discriminant;
    uint32_t parameter_0;
    uint32_t parameter_1;

    if (unpacker.from_array(discriminant, parameter_0, parameter_1))
    {
        buffer.clear();
        return PackedMessage{discriminant, parameter_0, parameter_1};
    }

    return std::nullopt;
}

size_t send(const PackedMessage &packed)
{
    MsgPack::Packer packer;
    packer.to_array(packed.discriminant, packed.parameter_0,
                    packed.parameter_1);
    return Serial.write(packer.data(), packer.size());
}

size_t send(MessageType message_type)
{
    PackedMessage packed = {static_cast<uint8_t>(message_type), 0, 0};
    return send(packed);
}

size_t send(MessageType message_type, uint32_t parameter_0)
{
    PackedMessage packed = {static_cast<uint8_t>(message_type), parameter_0, 0};
    return send(packed);
}

size_t send(MessageType message_type, uint32_t parameter_0,
            uint32_t parameter_1)
{
    PackedMessage packed = {static_cast<uint8_t>(message_type), parameter_0, parameter_1};
    return send(packed);
}

} // namespace message

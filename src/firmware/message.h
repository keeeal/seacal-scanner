#pragma once

#include <MsgPack.h>

#include "settings.h"

namespace message
{

// ==== MESSAGE ====

enum MessageType
{
    Ping = 0x00,
    Pong = 0x01,
    SetSpeed = 0x10,
    MoveTo = 0x11,
    MoveComplete = 0x12,
    ZeroBase = 0x13,
    StartPressed = 0x20,
    StopPressed = 0x21,
    UnexpectedMsg = 0x30,
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
    PackedMessage packed = {message_type, 0, 0};
    return send(packed);
}

size_t send(MessageType message_type, uint32_t parameter_0)
{
    PackedMessage packed = {message_type, parameter_0, 0};
    return send(packed);
}

size_t send(MessageType message_type, uint32_t parameter_0,
            uint32_t parameter_1)
{
    PackedMessage packed = {message_type, parameter_0, parameter_1};
    return send(packed);
}

} // namespace message

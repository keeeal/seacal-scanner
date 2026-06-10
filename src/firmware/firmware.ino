#include "hardware.h"
#include "homing.h"
#include "message.h"
#include "settings.h"
#include "stepper.h"

std::vector<uint8_t> SERIAL_BUFFER;
std::deque<message::PackedMessage> MESSAGE_QUEUE;

uint32_t BASE_TARGET = 0;
uint32_t ARM_TARGET = 0;
bool BASE_REVERSED = false;
bool ARM_REVERSED = false;
bool MOVE_COMPLETE = true;
bool STOPPED = false;

// Call as frequently as possible
bool read_serial()
{
    std::optional<message::PackedMessage> packed =
        message::serial_receive(SERIAL_BUFFER);
    if (!packed.has_value())
        return false;

    // Respond to ping immediately rather than queueing it
    if (packed->discriminant == message::MessageType::Ping)
    {
        // This pulse is a useful visual indicator but the delay also seems to
        // help when connecting to some (older windows) host devices
        hardware::green_led.high();
        delay(100);
        hardware::green_led.low();
        message::send(message::MessageType::Pong);
    }
    else
    {
        MESSAGE_QUEUE.push_back(packed.value());
        return true;
    }
    return false;
}

void setup()
{
    // Setup serial
    SERIAL_BUFFER.reserve(SERIAL_BUFFER_SIZE);
    Serial.begin(SERIAL_BAUD);

    // Setup hardware
    hardware::setup();
}

void loop()
{
    read_serial();

    // Handle button behaviour
    if (hardware::stop_button.read() == HIGH)
    {
        hardware::steppers.reset();
        hardware::red_led.high();
        message::send(message::MessageType::StopPressed);
        STOPPED = true;
        delay(500);
        return;
    }
    else if (STOPPED)
    {
        hardware::steppers.disable();
        hardware::fan.low();
        hardware::red_led.low();
        homing::reset();
        message::send(message::MessageType::StopReleased);
        MESSAGE_QUEUE.clear();
        BASE_TARGET = 0;
        ARM_TARGET = 0;
        MOVE_COMPLETE = true;
        STOPPED = false;
    }
    if (hardware::start_button.pressed())
        message::send(message::MessageType::StartPressed);

    // If currently homing, only do that
    if (homing::run(ARM_REVERSED))
        return;
    int32_t num_arm_steps = homing::num_arm_steps();
    if (homing::is_complete() && num_arm_steps == 0)
    {
        message::send(message::MessageType::HomingError);
        return;
    }

    // There are 1024 positions per base revolution and 1024 total for the arm
    int32_t base_position =
        (BASE_REVERSED ? -1 : 1) * BASE_TARGET * NUM_BASE_STEPS / 1024;
    int32_t arm_position =
        (ARM_REVERSED ? -1 : 1) * ARM_TARGET * num_arm_steps / 1024;
    arm_position = min(max(0, arm_position), num_arm_steps);
    hardware::base.moveTo(base_position);
    hardware::arm.moveTo(arm_position);

    // Run steppers towards target location
    bool arm_moving = hardware::arm.run();
    bool base_moving = hardware::base.run();
    if (!arm_moving && !base_moving && !MOVE_COMPLETE)
    {
        MOVE_COMPLETE = true;
        hardware::steppers.reset();
        message::send(message::MessageType::MoveComplete, BASE_TARGET,
                      ARM_TARGET);
    }

    if (MESSAGE_QUEUE.empty())
        return;

    message::PackedMessage packed = MESSAGE_QUEUE.front();
    MESSAGE_QUEUE.pop_front();

    switch (packed.discriminant)
    {

    // Speed parameters are signed integer percentages of the initial speed
    case message::MessageType::SetSpeed: {
        int32_t base_speed_percent =
            min(static_cast<int32_t>(packed.parameter_0), 200);
        int32_t arm_speed_percent =
            min(static_cast<int32_t>(packed.parameter_1), 200);
        int32_t base_speed = base_speed_percent * INIT_BASE_SPEED / 100;
        int32_t arm_speed = arm_speed_percent * INIT_ARM_SPEED / 100;

        hardware::base.setMaxSpeed(base_speed);
        hardware::base.setAcceleration(base_speed);
        hardware::arm.setMaxSpeed(arm_speed);
        hardware::arm.setAcceleration(arm_speed);

        break;
    }

    // Target parameters are integers representing a unique position
    case message::MessageType::MoveTo:
        MOVE_COMPLETE = false;
        BASE_TARGET = (BASE_REVERSED ? -1 : 1) * packed.parameter_0;
        ARM_TARGET = (ARM_REVERSED ? -1 : 1) * packed.parameter_1;

        hardware::fan.high();
        hardware::steppers.enable();
        hardware::steppers.cancelReset();

        if (!homing::is_started())
        {
            message::send(message::MessageType::HomingInProgress);
            homing::start();
        }

        break;

    case message::MessageType::ZeroBase:
        hardware::base.setCurrentPosition(0);
        break;

    case message::MessageType::DisableSteppers:
        hardware::steppers.disable();
        hardware::fan.low();
        break;

    default:
        message::send(message::MessageType::UnexpectedMsg, packed.discriminant);
        break;
    }
}

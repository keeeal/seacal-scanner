#include <AccelStepper.h>
#include <Button.h>
// #include <Serial.h>

#include "message.h"
#include "output.h"
#include "settings.h"
#include "stepper_settings.h"

StepperSettings STEPPER_SETTINGS(ENABLE_PIN, MS1_PIN, MS2_PIN, MS3_PIN,
                                 RESET_PIN);
AccelStepper BASE_STEPPER(AccelStepper::DRIVER, BASE_STEP_PIN, BASE_DIR_PIN);
AccelStepper ARM_STEPPER(AccelStepper::DRIVER, ARM_STEP_PIN, ARM_DIR_PIN);

Button START_BUTTON(START_BUTTON_PIN);
Button STOP_BUTTON(STOP_BUTTON_PIN);
Button TOP_LIMIT_SWITCH(TOP_LIMIT_PIN);
Button BOTTOM_LIMIT_SWITCH(BOTTOM_LIMIT_PIN);

Output FAN(FAN_PIN);
Output GREEN_LED(GREEN_LED_PIN);
Output RED_LED(RED_LED_PIN);

std::vector<uint8_t> SERIAL_BUFFER;
std::deque<message::PackedMessage> MESSAGE_QUEUE;
std::deque<uint8_t> CAMERA_QUEUE;

uint32_t TOP_LIMIT = 0;
uint32_t BOTTOM_LIMIT = 0;
uint32_t BASE_TARGET = 0;
uint32_t ARM_TARGET = 0;
bool MOVE_COMPLETE = true;

// Call as frequently as possible
bool read_serial()
{

    std::optional<message::PackedMessage> packed =
        message::serial_receive(SERIAL_BUFFER);
    if (!packed.has_value())
        return false;

    // Respond to ping immediately rather than queueing it
    if (packed->discriminant == message::MessageType::Ping)
        message::send(message::MessageType::Pong);
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
    SERIAL_BUFFER.reserve(64);
    Serial.begin(2e6);

    // Setup steppers
    STEPPER_SETTINGS.begin();
    STEPPER_SETTINGS.setStepMode(StepperSettings::StepMode::THIRTY_SECOND_STEP);
    BASE_STEPPER.setMaxSpeed(INIT_BASE_SPEED);
    BASE_STEPPER.setAcceleration(INIT_BASE_SPEED);
    ARM_STEPPER.setMaxSpeed(INIT_ARM_SPEED);
    ARM_STEPPER.setAcceleration(INIT_ARM_SPEED);

    // Setup inputs and outputs
    START_BUTTON.begin();
    STOP_BUTTON.begin();
    TOP_LIMIT_SWITCH.begin();
    BOTTOM_LIMIT_SWITCH.begin();
    FAN.begin();
    GREEN_LED.begin();
    RED_LED.begin();

    // Setup LED
    pinMode(LED_BUILTIN, OUTPUT);
    digitalWrite(LED_BUILTIN, LOW);
}

void home()
{
    // ARM_STEPPER.setSpeed(HOMING_SPEED_COARSE);
    // while (!TOP_LIMIT_SWITCH.pressed())
    // {
    //     read_serial();
    //     ARM_STEPPER.runSpeed();
    // }

    // ARM_STEPPER.setSpeed(HOMING_SPEED_FINE);
    // ARM_STEPPER.move(-HOMING_RETRACT_STEPS);
    // while (ARM_STEPPER.run())
    //     read_serial();

    // ARM_STEPPER.setSpeed(HOMING_SPEED_FINE);
    // while (TOP_LIMIT_SWITCH.read() != Button::PRESSED)
    // {
    //     read_serial();
    //     ARM_STEPPER.runSpeed();
    // }
    // TOP_LIMIT = ARM_STEPPER.currentPosition();

    // ARM_STEPPER.setSpeed(-HOMING_SPEED_COARSE);
    // while (!BOTTOM_LIMIT_SWITCH.pressed())
    // {
    //     read_serial();
    //     ARM_STEPPER.runSpeed();
    // }

    // ARM_STEPPER.setSpeed(-HOMING_SPEED_FINE);
    // ARM_STEPPER.move(HOMING_RETRACT_STEPS);
    // while (ARM_STEPPER.run())
    //     read_serial();

    // ARM_STEPPER.setSpeed(-HOMING_SPEED_FINE);
    // while (BOTTOM_LIMIT_SWITCH.read() != Button::PRESSED)
    // {
    //     read_serial();
    //     ARM_STEPPER.runSpeed();
    // }
    // BOTTOM_LIMIT = ARM_STEPPER.currentPosition();
    TOP_LIMIT = 1000;
    BOTTOM_LIMIT = 0;
}

void loop()
{
    read_serial();

    // if (STOP_BUTTON.read() == HIGH)
    // {
    //     STEPPER_SETTINGS.reset();
    //     RED_LED.on();
    //     return;
    // }

    if (!ARM_STEPPER.run() && !BASE_STEPPER.run() && !MOVE_COMPLETE)
    {
        MOVE_COMPLETE = true;
        STEPPER_SETTINGS.reset();
        message::send(message::MessageType::MoveComplete, BASE_TARGET,
                      ARM_TARGET);
    }

    if (MESSAGE_QUEUE.empty())
        return;

    message::PackedMessage packed = MESSAGE_QUEUE.front();
    MESSAGE_QUEUE.pop_front();

    switch (packed.discriminant)
    {

    // Messages to forward to the cameras
    case message::MessageType::SetSpeed: {
        uint32_t base_speed = packed.parameter_0 * INIT_BASE_SPEED / 100;
        uint32_t arm_speed = packed.parameter_1 * INIT_ARM_SPEED / 100;
        BASE_STEPPER.setMaxSpeed(base_speed);
        BASE_STEPPER.setAcceleration(base_speed);
        ARM_STEPPER.setMaxSpeed(arm_speed);
        ARM_STEPPER.setAcceleration(arm_speed);
        break;
    }

    case message::MessageType::MoveTo: {
        MOVE_COMPLETE = false;
        BASE_TARGET = packed.parameter_0;
        ARM_TARGET = packed.parameter_1;
        STEPPER_SETTINGS.enable();
        STEPPER_SETTINGS.cancelReset();

        if (TOP_LIMIT == BOTTOM_LIMIT)
            home();

        uint32_t base_position = packed.parameter_0 * NUM_BASE_STEPS / 1024;
        uint32_t arm_position =
            packed.parameter_1 * (TOP_LIMIT - BOTTOM_LIMIT) / 1024;

        BASE_STEPPER.moveTo(base_position);
        ARM_STEPPER.moveTo(arm_position);

        break;
    }

    case message::MessageType::ZeroBase:
        BASE_STEPPER.setCurrentPosition(0);
        break;

    default:
        message::send(message::MessageType::UnexpectedMsg, packed.discriminant);
        break;
    }
}

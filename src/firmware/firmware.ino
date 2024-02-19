#include <AccelStepper.h>
#include <StateMachine.h>

#include "constants.h"
#include "homing.h"
#include "idle.h"
#include "scanning.h"
#include "stopped.h"

AccelStepper BASE_STEPPER(AccelStepper::DRIVER, BASE_STEP_PIN, BASE_DIR_PIN);
AccelStepper ARM_STEPPER(AccelStepper::DRIVER, ARM_STEP_PIN, ARM_DIR_PIN);

StateMachine STATE_MACHINE = StateMachine();

void setup()
{
    pinMode(ENABLE_PIN, OUTPUT);
    pinMode(MS1_PIN, OUTPUT);
    pinMode(MS2_PIN, OUTPUT);
    pinMode(MS3_PIN, OUTPUT);
    pinMode(CAMERA_PIN, OUTPUT);

    digitalWrite(ENABLE_PIN, LOW);
    digitalWrite(MS1_PIN, HIGH);
    digitalWrite(MS2_PIN, HIGH);
    digitalWrite(MS3_PIN, HIGH);
    digitalWrite(CAMERA_PIN, LOW);

    pinMode(TOP_LIMIT_PIN, INPUT_PULLUP);
    pinMode(BOTTOM_LIMIT_PIN, INPUT_PULLUP);
    pinMode(START_BUTTON_PIN, INPUT_PULLUP);
    pinMode(STOP_BUTTON_PIN, INPUT_PULLUP);

    ARM_STEPPER.setMaxSpeed(MAX_ARM_SPEED);
    ARM_STEPPER.setAcceleration(MAX_ARM_ACCELERATION);
    BASE_STEPPER.setMaxSpeed(MAX_BASE_SPEED);
    BASE_STEPPER.setAcceleration(MAX_BASE_ACCELERATION);

    Homing::setup();
    Scanning::setup();

    State *idle = STATE_MACHINE.addState(&Idle::run);
    State *homing = STATE_MACHINE.addState(&Homing::run);
    State *scanning = STATE_MACHINE.addState(&Scanning::run);
    // State *stopped = STATE_MACHINE.addState(&Stopped::run);

    idle->addTransition(&Idle::toHoming, homing);
    homing->addTransition(&Homing::toScanning, scanning);
    scanning->addTransition(&Scanning::toIdle, idle);
}

void loop()
{
    STATE_MACHINE.run();
}

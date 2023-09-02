#include <AccelStepper.h>
#include <StateMachine.h>

#include "constants.h"
#include "homing.h"
#include "idle.h"
#include "scanning.h"
#include "stopped.h"

AccelStepper base_stepper(AccelStepper::DRIVER, BASE_STEP_PIN, BASE_DIR_PIN);
AccelStepper arm_stepper(AccelStepper::DRIVER, ARM_STEP_PIN, ARM_DIR_PIN);

StateMachine state_machine = StateMachine();

void setup()
{
    pinMode(ENABLE_PIN, OUTPUT);
    pinMode(MS1_PIN, OUTPUT);
    pinMode(MS2_PIN, OUTPUT);
    pinMode(MS3_PIN, OUTPUT);

    digitalWrite(ENABLE_PIN, LOW);
    digitalWrite(MS1_PIN, LOW);
    digitalWrite(MS2_PIN, LOW);
    digitalWrite(MS3_PIN, HIGH);

    pinMode(LIMIT_TOP_PIN, INPUT_PULLUP);
    pinMode(LIMIT_BOTTOM_PIN, INPUT_PULLUP);
    pinMode(START_BUTTON_PIN, INPUT_PULLUP);
    pinMode(STOP_BUTTON_PIN, INPUT_PULLUP);

    arm_stepper.setMaxSpeed(200);    // steps per second
    arm_stepper.setAcceleration(50); // steps per second per second

    State *idle = state_machine.addState(&Idle::run);
    State *homing = state_machine.addState(&Homing::run);
    State *scanning = state_machine.addState(&Scanning::run);
    State *stopped = state_machine.addState(&Stopped::run);

    idle->addTransition(&Idle::toScanning, scanning);
}

void loop()
{
}

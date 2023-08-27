#include <AccelStepper.h>

#include "constants.h"
#include "idle.h"
#include "scanning.h"
#include "state.h"
#include "stopped.h"

State *state;

AccelStepper base(AccelStepper::DRIVER, BASE_STEP_PIN, BASE_DIR_PIN);
AccelStepper arm(AccelStepper::DRIVER, ARM_STEP_PIN, ARM_DIR_PIN);

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

    arm.setMaxSpeed(200);    // steps per second
    arm.setAcceleration(50); // steps per second per second

    state = new Idle();
}

void loop()
{
    State *next_state = state->update();

    if (next_state != state)
    {
        state->on_exit();
        state = next_state;
        state->on_enter();
    }
}

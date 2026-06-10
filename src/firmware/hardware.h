#pragma once

#include <AccelStepper.h>
#include <Button.h>
#include <ezOutput.h>

#include "settings.h"
#include "stepper.h"

namespace hardware
{

// Stepper motors
stepper::Settings steppers(ENABLE_PIN, MS1_PIN, MS2_PIN, MS3_PIN, RESET_PIN);
AccelStepper base(AccelStepper::DRIVER, BASE_STEP_PIN, BASE_DIR_PIN);
AccelStepper arm(AccelStepper::DRIVER, ARM_STEP_PIN, ARM_DIR_PIN);

// Buttons
Button start_button(START_BUTTON_PIN);
Button stop_button(STOP_BUTTON_PIN);
Button top_limit_switch(TOP_LIMIT_PIN);
Button bottom_limit_switch(BOTTOM_LIMIT_PIN);

// Outputs
ezOutput fan(FAN_PIN);
ezOutput green_led(GREEN_LED_PIN);
ezOutput red_led(RED_LED_PIN);

void setup()
{
    // Setup stepper motors
    steppers.begin();
    steppers.setStepMode(stepper::Settings::StepMode::THIRTY_SECOND_STEP);
    base.setMaxSpeed(INIT_BASE_SPEED);
    base.setAcceleration(INIT_BASE_SPEED);
    arm.setMaxSpeed(INIT_ARM_SPEED);
    arm.setAcceleration(INIT_ARM_SPEED);

    // Setup buttons
    start_button.begin();
    stop_button.begin();
    top_limit_switch.begin();
    bottom_limit_switch.begin();

    // Setup built-in LED
    pinMode(LED_BUILTIN, OUTPUT);
    digitalWrite(LED_BUILTIN, LOW);
}

} // namespace hardware

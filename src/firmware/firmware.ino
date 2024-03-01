#include <AccelStepper.h>
#include <Button.h>
#include <StateMachine.h>

#include "camera.h"
#include "constants.h"
#include "homing.h"
#include "idle.h"
#include "output.h"
#include "scanning.h"
#include "stepper_settings.h"
#include "stopped.h"

StepperSettings STEPPER_SETTINGS(ENABLE_PIN, MS1_PIN, MS2_PIN, MS3_PIN,
                                 RESET_PIN);
AccelStepper BASE_STEPPER(AccelStepper::DRIVER, BASE_STEP_PIN, BASE_DIR_PIN);
AccelStepper ARM_STEPPER(AccelStepper::DRIVER, ARM_STEP_PIN, ARM_DIR_PIN);

Button START_BUTTON(START_BUTTON_PIN);
Button STOP_BUTTON(STOP_BUTTON_PIN);
Button TOP_LIMIT_SWITCH(TOP_LIMIT_PIN);
Button BOTTOM_LIMIT_SWITCH(BOTTOM_LIMIT_PIN);

Camera CAMERA(CAMERA_PIN);
Output FAN(FAN_PIN);
Output GREEN_LED(GREEN_LED_PIN);
Output RED_LED(RED_LED_PIN);

StateMachine STATE_MACHINE = StateMachine();

void setup()
{
    STEPPER_SETTINGS.setup();
    STEPPER_SETTINGS.setStepMode(StepperSettings::StepMode::THIRTY_SECOND_STEP);

    ARM_STEPPER.setMaxSpeed(MAX_ARM_SPEED);
    ARM_STEPPER.setAcceleration(MAX_ARM_ACCELERATION);
    BASE_STEPPER.setMaxSpeed(MAX_BASE_SPEED);
    BASE_STEPPER.setAcceleration(MAX_BASE_ACCELERATION);

    START_BUTTON.begin();
    STOP_BUTTON.begin();
    TOP_LIMIT_SWITCH.begin();
    BOTTOM_LIMIT_SWITCH.begin();

    CAMERA.setup();
    FAN.setup();
    GREEN_LED.setup();
    RED_LED.setup();

    Homing::setup();
    Scanning::setup();

    State *idle = STATE_MACHINE.addState(&Idle::run);
    State *homing = STATE_MACHINE.addState(&Homing::run);
    State *scanning = STATE_MACHINE.addState(&Scanning::run);
    State *stopped = STATE_MACHINE.addState(&Stopped::run);

    idle->addTransition(&Stopped::fromAny, stopped);
    idle->addTransition(&Idle::toHoming, homing);
    homing->addTransition(&Stopped::fromAny, stopped);
    homing->addTransition(&Homing::toScanning, scanning);
    scanning->addTransition(&Stopped::fromAny, stopped);
    scanning->addTransition(&Scanning::toIdle, idle);
    stopped->addTransition(&Stopped::toIdle, idle);
}

void loop()
{
    STATE_MACHINE.run();
}

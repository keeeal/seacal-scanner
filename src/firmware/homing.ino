#include "homing.h"
#include "scanning.h"

void Homing::setup()
{
    state_machine = StateMachine();

    move = state_machine.addState([]() {
        ARM_STEPPER.setSpeed(calculateSpeed());
        ARM_STEPPER.runSpeed();
    });

    retract = state_machine.addState([]() {
        if (state_machine.executeOnce)
            ARM_STEPPER.move(calculateRetractSteps());
    });

    complete = state_machine.addState([]() {});

    move->addTransition(
        []() {
            if (mode != coarse)
                return false;
            int pin = (direction == up) ? TOP_LIMIT_PIN : BOTTOM_LIMIT_PIN;
            if (digitalRead(pin) != LOW)
                return false;
            return true;
        },
        retract);

    retract->addTransition(
        []() {
            if (ARM_STEPPER.run())
                return false;
            mode = fine;
            return true;
        },
        move);

    move->addTransition(
        []() {
            if (mode != fine)
                return false;
            if (direction != up)
                return false;
            if (digitalRead(TOP_LIMIT_PIN) != LOW)
                return false;

            Scanning::setTopLimit(ARM_STEPPER.currentPosition());
            direction = down;
            mode = coarse;
            return true;
        },
        move);

    move->addTransition(
        []() {
            if (mode != fine)
                return false;
            if (direction != down)
                return false;
            if (digitalRead(BOTTOM_LIMIT_PIN) != LOW)
                return false;

            Scanning::setBottomLimit(ARM_STEPPER.currentPosition());
            return true;
        },
        complete);
}

void Homing::onEnter()
{
    Serial.println("HOMING");
    direction = up;
    mode = coarse;
    state_machine.transitionTo(move);
}

void Homing::run()
{
    if (STATE_MACHINE.executeOnce)
        Homing::onEnter();

    state_machine.run();
}

void Homing::onExit()
{
}

bool Homing::toScanning()
{
    if (isComplete())
    {
        Homing::onExit();
        return true;
    }
    return false;
}

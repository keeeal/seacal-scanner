#include <Button.h>

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
            return (direction == up) ? TOP_LIMIT_SWITCH.pressed()
                                     : BOTTOM_LIMIT_SWITCH.pressed();
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
            if (!TOP_LIMIT_SWITCH.read() == Button::PRESSED)
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
            if (!BOTTOM_LIMIT_SWITCH.read() == Button::PRESSED)
                return false;

            Scanning::setBottomLimit(ARM_STEPPER.currentPosition());
            return true;
        },
        complete);
}

void Homing::onEnter()
{
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

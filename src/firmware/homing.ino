#include "constants.h"
#include "homing.h"
#include "scanning.h"

void Homing::setup()
{
    state_machine = StateMachine();

    State *move = state_machine.addState([]() {
        if (state_machine.executeOnce)
        {
            ARM_STEPPER.setSpeed(calculateSpeed());
        }
        ARM_STEPPER.runSpeed();
    });

    State *retract = state_machine.addState([]() {
        if (state_machine.executeOnce)
        {
            retract_complete = false;
            ARM_STEPPER.move(calculateRetractSteps());
        }
        retract_complete = ARM_STEPPER.run();
    });

    State *complete = state_machine.addState([]() {});

    move->addTransition(
        []() {
            if (mode != coarse)
                return false;

            if (digitalRead(getLimitPin()) != LOW)
                return false;

            return true;
        },
        retract);

    retract->addTransition(
        []() {
            if (!retract_complete)
                return false;

            mode = fine;
            return true;
        },
        move);

    move->addTransition(
        []() {
            if (mode != fine)
                return false;

            if (digitalRead(getLimitPin()) != LOW)
                return false;

            switch (direction)
            {
            case up:
                Scanning::setTopLimit(ARM_STEPPER.currentPosition());
                break;
            case down:
                Scanning::setBottomLimit(ARM_STEPPER.currentPosition());
                homing_complete = true;
                return false;
            }

            toggleDirection();
            mode = coarse;
            return true;
        },
        move);

    move->addTransition([]() { return homing_complete; }, complete);
}

void Homing::onEnter()
{
    homing_complete = false;
    retract_complete = false;
    direction = up;
    mode = coarse;
    state_machine.transitionTo(0);
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
    if (homing_complete)
    {
        Homing::onExit();
        return true;
    }
    return false;
}

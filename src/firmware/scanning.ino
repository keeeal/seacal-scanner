#include <Button.h>

#include "constants.h"
#include "scanning.h"
#include "stepper_settings.h"

void Scanning::setup()
{
    state_machine = StateMachine();

    move = state_machine.addState([]() {
        if (state_machine.executeOnce)
        {
            float f1 = (float)photo_index / (float)(NUM_PHOTOS - 1);
            float f2 = round(NUM_REVOLUTIONS * f1) / NUM_REVOLUTIONS;

            // This is a fudge factor to account for the geometry of moving the
            // arm with a pulley. Without this, the arm moves more slowly at
            // the top than at the bottom.
            f2 = pow(f2, 1.5);

            BASE_STEPPER.moveTo((long)(f1 * NUM_REVOLUTIONS * NUM_BASE_STEPS));
            ARM_STEPPER.moveTo(
                (long)(f2 * (top_limit - bottom_limit) + bottom_limit));
        }
    });

    photo = state_machine.addState([]() {
        STEPPER_SETTINGS.reset();
        CAMERA.takePhoto();
        STEPPER_SETTINGS.cancelReset();
        photo_index++;
    });

    reset = state_machine.addState([]() {
        if (state_machine.executeOnce)
            ARM_STEPPER.moveTo(bottom_limit);
    });

    complete = state_machine.addState([]() {});

    move->addTransition(
        []() {
            bool limit_reached = TOP_LIMIT_SWITCH.read() == Button::PRESSED;
            bool arm_move_complete = limit_reached || !ARM_STEPPER.run();
            bool base_move_complete = !BASE_STEPPER.run();
            return arm_move_complete && base_move_complete;
        },
        photo);

    photo->addTransition([]() { return photo_index == NUM_PHOTOS; }, reset);

    photo->addTransition([]() { return true; }, move);

    reset->addTransition(
        []() { return BOTTOM_LIMIT_SWITCH.pressed() || !ARM_STEPPER.run(); },
        complete);
}

void Scanning::onEnter()
{
    photo_index = 0;
    state_machine.transitionTo(move);
}

void Scanning::run()
{
    if (STATE_MACHINE.executeOnce)
        Scanning::onEnter();

    state_machine.run();
}

void Scanning::onExit()
{
}

bool Scanning::toIdle()
{
    if (isComplete())
    {
        Scanning::onExit();
        return true;
    }
    return false;
}

void Scanning::setTopLimit(long position)
{
    top_limit = position;
}

void Scanning::setBottomLimit(long position)
{
    bottom_limit = position;
}

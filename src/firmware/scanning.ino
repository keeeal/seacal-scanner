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
            ARM_STEPPER.moveTo(calculateArmPosition());
            BASE_STEPPER.moveTo(calculateBasePosition());
        }
    });

    photo = state_machine.addState([]() {
        STEPPER_SETTINGS.reset();
        CAMERA.takePhoto();
        STEPPER_SETTINGS.cancelReset();
        current_base_position += 1;
        current_arm_position = current_base_position / NUM_BASE_POSITIONS;
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

    photo->addTransition(
        []() {
            // Reset after one photo has been taken from the top position.
            if (current_arm_position < NUM_ARM_POSITIONS - 1)
                return false;
            return current_base_position % NUM_ARM_POSITIONS > 0;
        },
        reset);

    photo->addTransition([]() { return true; }, move);

    reset->addTransition(
        []() { return BOTTOM_LIMIT_SWITCH.pressed() || !ARM_STEPPER.run(); },
        complete);
}

void Scanning::onEnter()
{
    current_arm_position = 0;
    current_base_position = 0;
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

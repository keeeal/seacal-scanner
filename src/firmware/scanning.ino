#include "constants.h"
#include "scanning.h"

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
        digitalWrite(CAMERA_PIN, HIGH);
        delay(100);
        digitalWrite(CAMERA_PIN, LOW);
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
            bool arm_move_complete = digitalRead(TOP_LIMIT_PIN) == LOW || !ARM_STEPPER.run();
            bool base_move_complete = !BASE_STEPPER.run();
            return arm_move_complete && base_move_complete;
        },
        photo);

    photo->addTransition(
        []() {
            if (current_arm_position < NUM_ARM_POSITIONS)
                return false;
            if (current_base_position < NUM_ARM_POSITIONS * NUM_BASE_POSITIONS)
                return false;
            return true;
        },
        reset);

    photo->addTransition([]() { return true; }, move);

    reset->addTransition([]() { return digitalRead(BOTTOM_LIMIT_PIN) == LOW || !ARM_STEPPER.run(); }, complete);
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

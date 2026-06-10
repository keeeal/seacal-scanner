#pragma once

#include "hardware.h"

namespace homing
{

enum class State
{
    NOT_STARTED,
    UP_COARSE,
    UP_RETRACT,
    UP_FINE,
    DOWN_COARSE,
    DOWN_RETRACT,
    DOWN_FINE,
    COMPLETE,
};

namespace
{

State state = State::NOT_STARTED;
int32_t _num_arm_steps = 0;

} // namespace

bool is_started()
{
    return state != State::NOT_STARTED;
}

bool is_complete()
{
    return state == State::COMPLETE;
}

int32_t num_arm_steps()
{
    if (state == State::COMPLETE)
        return _num_arm_steps;
    else
        return 0;
}

void reset()
{
    state = State::NOT_STARTED;
}

void start()
{
    state = State::UP_COARSE;
}

// Returns true during the homing sequence
bool run(bool reversed)
{
    int direction = reversed ? -1 : 1;
    switch (state)
    {

    case State::UP_COARSE:
        hardware::arm.setSpeed(direction * HOMING_SPEED_COARSE);
        if (hardware::top_limit_switch.pressed())
            state = State::UP_RETRACT;
        else
            hardware::arm.runSpeed();
        break;

    case State::UP_RETRACT:
        hardware::arm.setSpeed(-direction * HOMING_SPEED_FINE);
        if (hardware::top_limit_switch.released())
            state = State::UP_FINE;
        else
            hardware::arm.runSpeed();
        break;

    case State::UP_FINE:
        hardware::arm.setSpeed(direction * HOMING_SPEED_FINE);
        if (hardware::top_limit_switch.pressed())
        {
            _num_arm_steps = hardware::arm.currentPosition();
            state = State::DOWN_COARSE;
        }
        else
            hardware::arm.runSpeed();
        break;

    case State::DOWN_COARSE:
        hardware::arm.setSpeed(-direction * HOMING_SPEED_COARSE);
        if (hardware::bottom_limit_switch.pressed())
            state = State::DOWN_RETRACT;
        else
            hardware::arm.runSpeed();
        break;

    case State::DOWN_RETRACT:
        hardware::arm.setSpeed(direction * HOMING_SPEED_FINE);
        if (hardware::bottom_limit_switch.released())
            state = State::DOWN_FINE;
        else
            hardware::arm.runSpeed();
        break;

    case State::DOWN_FINE:
        hardware::arm.setSpeed(-direction * HOMING_SPEED_FINE);
        if (hardware::bottom_limit_switch.pressed())
        {
            _num_arm_steps -= hardware::arm.currentPosition();
            hardware::arm.setCurrentPosition(0);
            state = State::COMPLETE;
        }
        else
            hardware::arm.runSpeed();
        break;

    default:
        return false;
    }
    return true;
}

} // namespace homing

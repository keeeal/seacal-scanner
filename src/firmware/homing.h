#pragma once

#include <StateMachine.h>

#include "constants.h"

namespace Homing
{
namespace
{

StateMachine state_machine;

bool homing_complete;
bool retract_complete;

enum Direction
{
    up,
    down
} direction;

enum Speed
{
    coarse,
    fine
} mode;

void toggleDirection()
{
    switch (direction)
    {
    case up:
        direction = down;
        break;
    case down:
        direction = up;
        break;
    }
}

int getLimitPin()
{
    switch (direction)
    {
    case up:
        return TOP_LIMIT_PIN;
    case down:
        return BOTTOM_LIMIT_PIN;
    default:
        return -1;
    }
}

float calculateSpeed()
{
    float speed = ARM_DIR_UP;
    speed = (direction == up) ? speed : -speed;

    switch (mode)
    {
    case coarse:
        speed *= HOMING_SPEED_COARSE;
        break;
    case fine:
        speed *= HOMING_SPEED_FINE;
        break;
    }

    return speed;
}

int calculateRetractSteps()
{
    long steps = ARM_DIR_UP * HOMING_RETRACT_STEPS;
    steps = (direction == up) ? -steps : steps;
    return steps;
}

} // namespace

void setup();
void onEnter();
void run();
void onExit();
bool toScanning();

} // namespace Homing

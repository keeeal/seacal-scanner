#pragma once

#include <StateMachine.h>

#include "constants.h"

namespace Homing
{
namespace
{

StateMachine state_machine;
State *move;
State *retract;
State *complete;

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

bool isComplete()
{
    return state_machine.currentState == complete->index;
}

float calculateSpeed()
{
    float speed = ARM_UP_DIR;
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
    long steps = ARM_UP_DIR * HOMING_RETRACT_STEPS;
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

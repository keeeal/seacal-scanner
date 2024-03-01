#pragma once

#include <StateMachine.h>

#include "constants.h"

namespace Scanning
{

namespace
{

StateMachine state_machine;
State *move;
State *photo;
State *reset;
State *complete;

long top_limit;    // Steps
long bottom_limit; // Steps

unsigned int current_arm_position;
unsigned int current_base_position;

bool isComplete()
{
    return state_machine.currentState == complete->index;
}

long calculateArmPosition()
{
    float f = (float)(current_arm_position + 1) / (float)(NUM_ARM_POSITIONS);
    f = pow(f, 1.5); // This is a fudge factor
    return (long)(f * (top_limit - bottom_limit) + bottom_limit);
}

long calculateBasePosition()
{
    float f = (float)current_base_position / (float)NUM_BASE_POSITIONS;
    return (long)(f * NUM_BASE_STEPS);
}

} // namespace

void setup();
void onEnter();
void run();
void onExit();
bool toIdle();

void setTopLimit(long position);
void setBottomLimit(long position);

} // namespace Scanning

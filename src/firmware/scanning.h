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

double fractions[NUM_PHOTOS];
unsigned int photo_index;

bool isComplete()
{
    return state_machine.currentState == complete->index;
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

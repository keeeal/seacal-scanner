#include "constants.h"
#include "homing.h"
#include "scanning.h"

void Homing::onEnter()
{
}

void Homing::run()
{
    if (state_machine.executeOnce)
        Homing::onEnter();

    Scanning::setLimits(0, 0);
}

void Homing::onExit()
{
}

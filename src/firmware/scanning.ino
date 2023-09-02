#include "constants.h"
#include "scanning.h"

void Scanning::onEnter()
{
}

void Scanning::run()
{
    if (state_machine.executeOnce)
        Scanning::onEnter();
}

void Scanning::onExit()
{
}

void Scanning::setLimits(long top_limit, long bottom_limit)
{
}

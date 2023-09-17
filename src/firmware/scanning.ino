#include "constants.h"
#include "scanning.h"

void Scanning::onEnter()
{
}

void Scanning::run()
{
    if (STATE_MACHINE.executeOnce)
        Scanning::onEnter();
}

void Scanning::onExit()
{
}

void Scanning::setTopLimit(long position)
{
    top_limit = position;
}

void Scanning::setBottomLimit(long position)
{
    bottom_limit = position;
}

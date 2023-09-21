#include "constants.h"
#include "stopped.h"

void Stopped::onEnter()
{
}

void Stopped::run()
{
    if (STATE_MACHINE.executeOnce)
        Stopped::onEnter();
}

void Stopped::onExit()
{
}

#include "constants.h"
#include "stopped.h"

void Stopped::onEnter()
{
}

void Stopped::run()
{
    if (state_machine.executeOnce)
        Stopped::onEnter();
}

void Stopped::onExit()
{
}

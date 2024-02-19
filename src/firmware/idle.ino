#include "constants.h"
#include "idle.h"

void Idle::onEnter()
{
    // disable steppers
    digitalWrite(ENABLE_PIN, HIGH);
}

void Idle::run()
{
    if (STATE_MACHINE.executeOnce)
        Idle::onEnter();
}

void Idle::onExit()
{
    // enable steppers
    digitalWrite(ENABLE_PIN, LOW);
}

bool Idle::toHoming()
{
    if (!complete)
    {
        complete = true;
        Idle::onExit();
        return true;
    }
    return false;
}

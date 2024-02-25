#include "constants.h"
#include "idle.h"

void Idle::onEnter()
{
    STEPPER_SETTINGS.disable();
    FAN.off();
}

void Idle::run()
{
    if (STATE_MACHINE.executeOnce)
        Idle::onEnter();
}

void Idle::onExit()
{
    FAN.on();
    STEPPER_SETTINGS.enable();
}

bool Idle::toHoming()
{
    if (START_BUTTON.pressed())
    {
        Idle::onExit();
        return true;
    }
    return false;
}

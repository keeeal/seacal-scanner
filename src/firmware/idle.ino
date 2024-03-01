#include "idle.h"

void Idle::onEnter()
{
    STEPPER_SETTINGS.disable();
    FAN.off();
    GREEN_LED.off();
    RED_LED.off();
}

void Idle::run()
{
    if (STATE_MACHINE.executeOnce)
        Idle::onEnter();
}

void Idle::onExit()
{

    STEPPER_SETTINGS.enable();
    FAN.on();
    GREEN_LED.on();
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

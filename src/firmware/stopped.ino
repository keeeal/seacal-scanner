#include "stepper_settings.h"
#include "stopped.h"

void Stopped::onEnter()
{
    STEPPER_SETTINGS.reset();
    RED_LED.on();
}

void Stopped::run()
{
    if (STATE_MACHINE.executeOnce)
        Stopped::onEnter();
}

void Stopped::onExit()
{
    STEPPER_SETTINGS.cancelReset();
    RED_LED.off();
}

bool Stopped::fromAny()
{
    // Circuit is open when button is pressed.
    return STOP_BUTTON.read() == HIGH;
}

bool Stopped::toIdle()
{
    if (STOP_BUTTON.read() == LOW)
    {
        Stopped::onExit();
        return true;
    }
    return false;
}

#include "constants.h"
#include "idle.h"

void Idle::onEnter()
{
    // disable steppers
    digitalWrite(ENABLE_PIN, HIGH);
}

void Idle::run()
{
    if (state_machine.executeOnce)
        Idle::onEnter();
}

void Idle::onExit()
{
    // enable steppers
    digitalWrite(ENABLE_PIN, LOW);
}

bool Idle::toScanning()
{
    if (digitalRead(START_BUTTON_PIN) == LOW)
    {
        Idle::onExit();
        return true;
    }
    return false;
}

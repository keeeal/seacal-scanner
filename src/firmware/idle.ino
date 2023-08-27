#include "idle.h"
#include "scanning.h"

void Idle::on_enter()
{
    // disable steppers
    digitalWrite(ENABLE_PIN, HIGH);
}

void Idle::on_exit()
{
    // enable steppers
    digitalWrite(ENABLE_PIN, LOW);
}

State *Idle::update()
{
    if (digitalRead(START_BUTTON_PIN) == LOW)
    {
        return new Scanning();
    }
    return this;
}

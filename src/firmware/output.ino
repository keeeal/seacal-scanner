#include "output.h"

Output::Output(int pin) : pin(pin), state(false)
{
}

void Output::setup()
{
    pinMode(pin, OUTPUT);
    off();
}

void Output::high()
{
    digitalWrite(pin, HIGH);
    state = true;
}

void Output::low()
{
    digitalWrite(pin, LOW);
    state = false;
}

bool Output::isHigh()
{
    return state;
}

#include "output.h"

Output::Output(int pin) : _pin(pin), _mode(Mode::ON_IS_HIGH), _state(false)
{
}

Output::Output(int pin, Mode mode) : _pin(pin), _mode(mode), _state(false)
{
}

void Output::setup()
{
    pinMode(_pin, OUTPUT);
    off();
}

void Output::high()
{
    digitalWrite(_pin, HIGH);
    _state = true;
}

void Output::low()
{
    digitalWrite(_pin, LOW);
    _state = false;
}

bool Output::isHigh()
{
    return _state;
}

void Output::on()
{
    switch (_mode)
    {
    case Mode::ON_IS_HIGH:
        high();
        break;
    case Mode::ON_IS_LOW:
        low();
        break;
    }
}

void Output::off()
{
    switch (_mode)
    {
    case Mode::ON_IS_HIGH:
        low();
        break;
    case Mode::ON_IS_LOW:
        high();
        break;
    }
}

bool Output::isOn()
{
    switch (_mode)
    {
    case Mode::ON_IS_HIGH:
        return isHigh();
    case Mode::ON_IS_LOW:
        return !isHigh();
    }
}

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
    (_mode == Mode::ON_IS_HIGH) ? high() : low();
}

void Output::off()
{
    (_mode == Mode::ON_IS_HIGH) ? low() : high();
}

bool Output::isOn()
{
    return (_mode == Mode::ON_IS_HIGH) ? isHigh() : !isHigh();
}

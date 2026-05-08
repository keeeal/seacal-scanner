#pragma once

class Output
{
  public:
    enum class Mode
    {
        ACTIVE_HIGH,
        ACTIVE_LOW,
    };

    Output(pin_size_t pin);
    Output(pin_size_t pin, Mode mode);
    void begin();
    void high();
    void low();
    bool isHigh();
    void on();
    void off();
    bool isOn();

  private:
    pin_size_t _pin;
    Mode _mode;
    bool _state;
};

Output::Output(pin_size_t pin)
    : _pin(pin), _mode(Mode::ACTIVE_HIGH), _state(false)
{
}

Output::Output(pin_size_t pin, Mode mode)
    : _pin(pin), _mode(mode), _state(false)
{
}

void Output::begin()
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
    (_mode == Mode::ACTIVE_HIGH) ? high() : low();
}

void Output::off()
{
    (_mode == Mode::ACTIVE_HIGH) ? low() : high();
}

bool Output::isOn()
{
    return (_mode == Mode::ACTIVE_HIGH) ? isHigh() : !isHigh();
}

#pragma once

class Output
{
  public:
    enum class Mode
    {
        ON_IS_HIGH,
        ON_IS_LOW,
    };

    Output(int pin);
    Output(int pin, Mode mode);
    void setup();
    void high();
    void low();
    bool isHigh();
    void on();
    void off();
    bool isOn();

  private:
    int _pin;
    Mode _mode;
    bool _state;
};

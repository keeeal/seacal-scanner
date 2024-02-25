#pragma once

class Output
{
  public:
    Output(int pin);
    void setup();
    void high();
    void low();
    bool isHigh();

  private:
    int pin;
    bool state;
};

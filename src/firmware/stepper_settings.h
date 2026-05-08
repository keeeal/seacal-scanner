#pragma once

#include "output.h"

class StepperSettings
{
  public:
    enum class StepMode
    {
        STANDBY,
        FULL_STEP,
        HALF_STEP_A,
        HALF_STEP_B,
        QUARTER_STEP,
        EIGHTH_STEP,
        SIXTEENTH_STEP,
        THIRTY_SECOND_STEP,
    };

    StepperSettings(int enable_pin, int ms1_pin, int ms2_pin, int ms3_pin,
                    int reset_pin);
    void begin();
    void enable();
    void disable();
    void setStepMode(StepMode step_mode);
    void reset();
    void cancelReset();

  private:
    Output _enable;
    Output _ms1;
    Output _ms2;
    Output _ms3;
    Output _reset;
};

StepperSettings::StepperSettings(int enable_pin, int ms1_pin, int ms2_pin,
                                 int ms3_pin, int reset_pin)
    : _enable(Output(enable_pin)), _ms1(Output(ms1_pin)), _ms2(Output(ms2_pin)),
      _ms3(Output(ms3_pin)), _reset(Output(reset_pin))
{
}

void StepperSettings::begin()
{
    _enable.begin();
    _ms1.begin();
    _ms2.begin();
    _ms3.begin();
    _reset.begin();

    disable();
    setStepMode(StepMode::STANDBY);
    cancelReset();
}

void StepperSettings::enable()
{
    _enable.low();
}

void StepperSettings::disable()
{
    _enable.high();
}

void StepperSettings::setStepMode(StepMode step_mode)
{
    switch (step_mode)
    {
    case StepMode::STANDBY:
        _ms1.low();
        _ms2.low();
        _ms3.low();
        break;
    case StepMode::FULL_STEP:
        _ms1.low();
        _ms2.low();
        _ms3.high();
        break;
    case StepMode::HALF_STEP_A:
        _ms1.low();
        _ms2.high();
        _ms3.low();
        break;
    case StepMode::HALF_STEP_B:
        _ms1.high();
        _ms2.low();
        _ms3.low();
        break;
    case StepMode::QUARTER_STEP:
        _ms1.low();
        _ms2.high();
        _ms3.high();
        break;
    case StepMode::EIGHTH_STEP:
        _ms1.high();
        _ms2.low();
        _ms3.high();
        break;
    case StepMode::SIXTEENTH_STEP:
        _ms1.high();
        _ms2.high();
        _ms3.low();
        break;
    case StepMode::THIRTY_SECOND_STEP:
        _ms1.high();
        _ms2.high();
        _ms3.high();
        break;
    }
}

void StepperSettings::reset()
{
    _reset.high();
}

void StepperSettings::cancelReset()
{
    _reset.low();
}

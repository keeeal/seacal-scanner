#include "stepper_settings.h"

StepperSettings::StepperSettings(int enable_pin, int ms1_pin, int ms2_pin,
                                 int ms3_pin, int reset_pin)
    : _enable(Output(enable_pin)), _ms1(Output(ms1_pin)), _ms2(Output(ms2_pin)),
      _ms3(Output(ms3_pin)), _reset(Output(reset_pin))
{
}

void StepperSettings::setup()
{
    _enable.setup();
    _ms1.setup();
    _ms2.setup();
    _ms3.setup();
    _reset.setup();

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

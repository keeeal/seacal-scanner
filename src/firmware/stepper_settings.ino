#include "stepper_settings.h"

StepperSettings::StepperSettings(int enable_pin, int ms1_pin, int ms2_pin,
                                 int ms3_pin, int reset_pin)
    : enable(Output(enable_pin)), ms1(Output(ms1_pin)), ms2(Output(ms2_pin)),
      ms3(Output(ms3_pin)), reset(Output(reset_pin))
{
}

void StepperSettings::setup()
{
    enable.setup();
    ms1.setup();
    ms2.setup();
    ms3.setup();
    reset.setup();

    disable();
    setStepMode(StepMode::STANDBY);
    cancelReset();
}

void StepperSettings::enable()
{
    enable.low();
}

void StepperSettings::disable()
{
    enable.high();
}

void StepperSettings::setStepMode(StepMode step_mode)
{
    switch (step_mode)
    {
    case StepMode::STANDBY:
        ms1.low();
        ms2.low();
        ms3.low();
        break;
    case StepMode::FULL_STEP:
        ms1.low();
        ms2.low();
        ms3.high();
        break;
    case StepMode::HALF_STEP_A:
        ms1.low();
        ms2.high();
        ms3.low();
        break;
    case StepMode::HALF_STEP_B:
        ms1.high();
        ms2.low();
        ms3.low();
        break;
    case StepMode::QUARTER_STEP:
        ms1.low();
        ms2.high();
        ms3.high();
        break;
    case StepMode::EIGHTH_STEP:
        ms1.high();
        ms2.low();
        ms3.high();
        break;
    case StepMode::SIXTEENTH_STEP:
        ms1.high();
        ms2.high();
        ms3.low();
        break;
    case StepMode::THIRTY_SECOND_STEP:
        ms1.high();
        ms2.high();
        ms3.high();
        break;
    }
}

void StepperSettings::reset()
{
    reset.high();
}

void StepperSettings::cancelReset()
{
    reset.low();
}

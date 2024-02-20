#include "stepper_settings.h"

StepperSettings::StepperSettings(int enable_pin, int ms1_pin, int ms2_pin,
                                 int ms3_pin, int reset_pin)
    : enable_pin(enable_pin), ms1_pin(ms1_pin), ms2_pin(ms2_pin),
      ms3_pin(ms3_pin), reset_pin(reset_pin)
{
}

void StepperSettings::setup()
{
    pinMode(enable_pin, OUTPUT);
    pinMode(ms1_pin, OUTPUT);
    pinMode(ms2_pin, OUTPUT);
    pinMode(ms3_pin, OUTPUT);
    pinMode(reset_pin, OUTPUT);

    disable();
    setStepMode(StepMode::STANDBY);
    cancelReset();
}

void StepperSettings::enable()
{
    digitalWrite(enable_pin, LOW);
}

void StepperSettings::disable()
{
    digitalWrite(enable_pin, HIGH);
}

void StepperSettings::setStepMode(StepMode step_mode)
{
    switch (step_mode)
    {
    case StepMode::STANDBY:
        digitalWrite(ms1_pin, LOW);
        digitalWrite(ms2_pin, LOW);
        digitalWrite(ms3_pin, LOW);
        break;
    case StepMode::FULL_STEP:
        digitalWrite(ms1_pin, LOW);
        digitalWrite(ms2_pin, LOW);
        digitalWrite(ms3_pin, HIGH);
        break;
    case StepMode::HALF_STEP_A:
        digitalWrite(ms1_pin, LOW);
        digitalWrite(ms2_pin, HIGH);
        digitalWrite(ms3_pin, LOW);
        break;
    case StepMode::HALF_STEP_B:
        digitalWrite(ms1_pin, HIGH);
        digitalWrite(ms2_pin, LOW);
        digitalWrite(ms3_pin, LOW);
        break;
    case StepMode::QUARTER_STEP:
        digitalWrite(ms1_pin, LOW);
        digitalWrite(ms2_pin, HIGH);
        digitalWrite(ms3_pin, HIGH);
        break;
    case StepMode::EIGHTH_STEP:
        digitalWrite(ms1_pin, HIGH);
        digitalWrite(ms2_pin, LOW);
        digitalWrite(ms3_pin, HIGH);
        break;
    case StepMode::SIXTEENTH_STEP:
        digitalWrite(ms1_pin, HIGH);
        digitalWrite(ms2_pin, HIGH);
        digitalWrite(ms3_pin, LOW);
        break;
    case StepMode::THIRTY_SECOND_STEP:
        digitalWrite(ms1_pin, HIGH);
        digitalWrite(ms2_pin, HIGH);
        digitalWrite(ms3_pin, HIGH);
        break;
    }
}

void StepperSettings::reset()
{
    digitalWrite(reset_pin, HIGH);
}

void StepperSettings::cancelReset()
{
    digitalWrite(reset_pin, LOW);
}

#pragma once

namespace stepper
{

class Settings
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

    Settings(pin_size_t enable_pin, pin_size_t ms1_pin, pin_size_t ms2_pin,
             pin_size_t ms3_pin, pin_size_t reset_pin);

    void begin();
    void enable();
    void disable();
    void setStepMode(StepMode step_mode);
    void reset();
    void cancelReset();

  private:
    pin_size_t _enable_pin;
    pin_size_t _ms1_pin;
    pin_size_t _ms2_pin;
    pin_size_t _ms3_pin;
    pin_size_t _reset_pin;
};

Settings::Settings(pin_size_t enable_pin, pin_size_t ms1_pin,
                   pin_size_t ms2_pin, pin_size_t ms3_pin, pin_size_t reset_pin)
    : _enable_pin(enable_pin), _ms1_pin(ms1_pin), _ms2_pin(ms2_pin),
      _ms3_pin(ms3_pin), _reset_pin(reset_pin)
{
}

void Settings::begin()
{
    pinMode(_enable_pin, OUTPUT);
    pinMode(_ms1_pin, OUTPUT);
    pinMode(_ms2_pin, OUTPUT);
    pinMode(_ms3_pin, OUTPUT);
    pinMode(_reset_pin, OUTPUT);

    disable();
    setStepMode(StepMode::STANDBY);
    cancelReset();
}

void Settings::enable()
{
    digitalWrite(_enable_pin, LOW);
}

void Settings::disable()
{
    digitalWrite(_enable_pin, HIGH);
}

void Settings::setStepMode(StepMode step_mode)
{
    switch (step_mode)
    {
    case StepMode::STANDBY:
        digitalWrite(_ms1_pin, LOW);
        digitalWrite(_ms2_pin, LOW);
        digitalWrite(_ms3_pin, LOW);
        break;
    case StepMode::FULL_STEP:
        digitalWrite(_ms1_pin, LOW);
        digitalWrite(_ms2_pin, LOW);
        digitalWrite(_ms3_pin, HIGH);
        break;
    case StepMode::HALF_STEP_A:
        digitalWrite(_ms1_pin, LOW);
        digitalWrite(_ms2_pin, HIGH);
        digitalWrite(_ms3_pin, LOW);
        break;
    case StepMode::HALF_STEP_B:
        digitalWrite(_ms1_pin, HIGH);
        digitalWrite(_ms2_pin, LOW);
        digitalWrite(_ms3_pin, LOW);
        break;
    case StepMode::QUARTER_STEP:
        digitalWrite(_ms1_pin, LOW);
        digitalWrite(_ms2_pin, HIGH);
        digitalWrite(_ms3_pin, HIGH);
        break;
    case StepMode::EIGHTH_STEP:
        digitalWrite(_ms1_pin, HIGH);
        digitalWrite(_ms2_pin, LOW);
        digitalWrite(_ms3_pin, HIGH);
        break;
    case StepMode::SIXTEENTH_STEP:
        digitalWrite(_ms1_pin, HIGH);
        digitalWrite(_ms2_pin, HIGH);
        digitalWrite(_ms3_pin, LOW);
        break;
    case StepMode::THIRTY_SECOND_STEP:
        digitalWrite(_ms1_pin, HIGH);
        digitalWrite(_ms2_pin, HIGH);
        digitalWrite(_ms3_pin, HIGH);
        break;
    }
}

// Locks motor to the nearest full step
void Settings::reset()
{
    digitalWrite(_reset_pin, HIGH);
}

void Settings::cancelReset()
{
    digitalWrite(_reset_pin, LOW);
}

} // namespace stepper

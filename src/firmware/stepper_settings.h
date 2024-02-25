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
    void setup();
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

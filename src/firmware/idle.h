#pragma once

#include "state.h"

class Idle : public State
{
  public:
    void on_enter();
    void on_exit();
    State *update();
};

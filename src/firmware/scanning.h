#pragma once

#include "state.h"

class Scanning : public State
{
  public:
    void on_enter();
    void on_exit();
    State *update();

  private:
    int top_limit;
    int bottom_limit;
};

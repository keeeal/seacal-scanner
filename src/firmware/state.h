#pragma once

class State
{
  public:
    virtual void on_enter() = 0;
    virtual void on_exit() = 0;
    virtual State *update() = 0;
};

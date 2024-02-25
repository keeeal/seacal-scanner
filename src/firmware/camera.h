#pragma once

#include "output.h"

class Camera
{
  public:
    Camera(int pin);
    void setup();
    void takePhoto();

  private:
    Output _output;
};

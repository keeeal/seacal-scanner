#pragma once

class Camera
{
  public:
    Camera(int pin);
    void setup();
    void takePhoto();

  private:
    int pin;
};

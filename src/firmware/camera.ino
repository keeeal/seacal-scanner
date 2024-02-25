#include "camera.h"

Camera::Camera(int pin) : _output(Output(pin))
{
}

void Camera::setup()
{
    _output.setup();
    _output.low();
}

void Camera::takePhoto()
{
    _output.high();
    delay(100);
    _output.low();
}

#include "camera.h"

Camera::Camera(int pin) : output(Output(pin))
{
}

void Camera::setup()
{
    output.setup();
    output.low();
}

void Camera::takePhoto()
{
    output.high();
    delay(100);
    output.low();
}

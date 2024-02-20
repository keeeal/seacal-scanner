#include "camera.h"

Camera::Camera(int pin) : pin(pin)
{
}

void Camera::setup()
{
    pinMode(pin, OUTPUT);
    digitalWrite(pin, LOW);
}

void Camera::takePhoto()
{
    digitalWrite(pin, HIGH);
    delay(100);
    digitalWrite(pin, LOW);
}

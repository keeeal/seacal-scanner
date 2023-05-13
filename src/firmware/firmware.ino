#include <AccelStepper.h>

// Define the base motor characteristics
#define BASE_PIN_1 8
#define BASE_PIN_2 9
#define BASE_PIN_3 10
#define BASE_PIN_4 11
#define BASE_STEPS 200
#define BASE_GEAR_RATIO 140 / 12

AccelStepper BASE_STEPPER;

void setup()
{
    AccelStepper BASE_STEPPER(AccelStepper::FULL4WIRE, BASE_PIN_1, BASE_PIN_2, BASE_PIN_3, BASE_PIN_4);
    BASE_STEPPER.setAcceleration(2); // Steps per second per second
    BASE_STEPPER.setMaxSpeed(100);   // Steps per second
}

void loop()
{
    // Move the stepper motor 360 degrees clockwise
    BASE_STEPPER.moveTo(BASE_STEPS);

    while (!BASE_STEPPER.run())
        continue;

    // Wait for a second
    delay(1000);

    // Move the stepper motor 360 degrees anticlockwise
    BASE_STEPPER.moveTo(0);

    while (!BASE_STEPPER.run())
        continue;

    // Wait for a second
    delay(1000);
}

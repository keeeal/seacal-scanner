#include <AccelStepper.h>

#define BASE_STP_PIN 7
#define BASE_DIR_PIN 9
#define BASE_STEPS 200
#define BASE_RATIO (140 / 12)

#define ARM_STP_PIN 10
#define ARM_DIR_PIN 11
#define ARM_STEPS 200

#define ENABLE 0
#define RESET 4
#define MS1 1
#define MS2 2
#define MS3 3

enum State
{
    IDLE,
    SCANNING,
    STOPPED,
};

State state;

AccelStepper base(AccelStepper::DRIVER, BASE_STP_PIN, BASE_DIR_PIN);
AccelStepper arm(AccelStepper::DRIVER, BASE_STP_PIN, BASE_DIR_PIN);

void setup()
{
    stepper.setMaxSpeed(200);    // Steps per second
    stepper.setAcceleration(50); // Steps per second per second

    pinMode(ENABLE, OUTPUT);
    pinMode(MS1, OUTPUT);
    pinMode(MS2, OUTPUT);
    pinMode(MS3, OUTPUT);

    digitalWrite(ENABLE, LOW);
    digitalWrite(MS1, LOW);
    digitalWrite(MS2, LOW);
    digitalWrite(MS3, HIGH);

    state = IDLE;
}

void loop()
{
    switch (state)
    {
    case IDLE:
        stepper.moveTo(BASE_STEPS);

        while (stepper.run())
            continue;

        stepper.moveTo(0);

        while (stepper.run())
            continue;

        break;

    case SCANNING:
        break;

    case STOPPED:
        break;
    }
}

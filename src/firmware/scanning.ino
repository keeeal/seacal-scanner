#include <Button.h>

#include "constants.h"
#include "scanning.h"
#include "stepper_settings.h"

void Scanning::setup()
{
    unsigned long num_integral_steps = 8 * NUM_PHOTOS;
    double distances[num_integral_steps];
    distances[0] = 0;

    double x = sin(MIN_ARM_ANGLE) * cos(0);
    double y = sin(MIN_ARM_ANGLE) * sin(0);
    double z = cos(MIN_ARM_ANGLE);

    for (unsigned long i = 1; i < num_integral_steps; i++)
    {
        double fraction = (double)i / (double)(num_integral_steps - 1);
        double arm_angle =
            MIN_ARM_ANGLE + (MAX_ARM_ANGLE - MIN_ARM_ANGLE) * fraction;
        double base_angle = 2 * M_PI * NUM_REVOLUTIONS * fraction;

        double xi = sin(arm_angle) * cos(base_angle);
        double yi = sin(arm_angle) * sin(base_angle);
        double zi = cos(arm_angle);

        double dx = xi - x;
        double dy = yi - y;
        double dz = zi - z;

        distances[i] = distances[i - 1] + sqrt(dx * dx + dy * dy + dz * dz);

        x = xi;
        y = yi;
        z = zi;
    }

    photo_index = 0;
    double photo_distance =
        distances[num_integral_steps - 1] / (NUM_PHOTOS - 1);

    for (unsigned int i = 0; i < num_integral_steps; i++)
    {
        if (distances[i] >= photo_index * photo_distance)
        {
            fractions[photo_index] =
                (double)i / (double)(num_integral_steps - 1);
            photo_index++;
        }
    }

    state_machine = StateMachine();

    move = state_machine.addState([]() {
        if (state_machine.executeOnce)
        {
            float f = fractions[photo_index];
            ARM_STEPPER.moveTo((long)(pow(f, 1.5) * (top_limit - bottom_limit) +
                                      bottom_limit));
            BASE_STEPPER.moveTo((long)(f * NUM_REVOLUTIONS * NUM_BASE_STEPS));
        }
    });

    photo = state_machine.addState([]() {
        STEPPER_SETTINGS.reset();
        CAMERA.takePhoto();
        STEPPER_SETTINGS.cancelReset();
        photo_index++;
    });

    reset = state_machine.addState([]() {
        if (state_machine.executeOnce)
            ARM_STEPPER.moveTo(bottom_limit);
    });

    complete = state_machine.addState([]() {});

    move->addTransition(
        []() {
            bool limit_reached = TOP_LIMIT_SWITCH.read() == Button::PRESSED;
            bool arm_move_complete = limit_reached || !ARM_STEPPER.run();
            bool base_move_complete = !BASE_STEPPER.run();
            return arm_move_complete && base_move_complete;
        },
        photo);

    photo->addTransition([]() { return photo_index == NUM_PHOTOS; }, reset);

    photo->addTransition([]() { return true; }, move);

    reset->addTransition(
        []() { return BOTTOM_LIMIT_SWITCH.pressed() || !ARM_STEPPER.run(); },
        complete);
}

void Scanning::onEnter()
{
    photo_index = 0;
    state_machine.transitionTo(move);
}

void Scanning::run()
{
    if (STATE_MACHINE.executeOnce)
        Scanning::onEnter();

    state_machine.run();
}

void Scanning::onExit()
{
}

bool Scanning::toIdle()
{
    if (isComplete())
    {
        Scanning::onExit();
        return true;
    }
    return false;
}

void Scanning::setTopLimit(long position)
{
    top_limit = position;
}

void Scanning::setBottomLimit(long position)
{
    bottom_limit = position;
}

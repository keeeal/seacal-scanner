#include <math.h>

#include "Arduino.h"
#include "stepper.h"

namespace stepper
{

Stepper::Stepper(int number_of_steps, int motor_pin_1, int motor_pin_2)
{
    this->stepper = &arduino::Stepper(number_of_steps, motor_pin_1, motor_pin_2);
    this->steps_per_degree = max(number_of_steps, 0) / 360.0;
}

Stepper::Stepper(int number_of_steps, int motor_pin_1, int motor_pin_2, int motor_pin_3, int motor_pin_4)
{
    this->stepper = &arduino::Stepper(number_of_steps, motor_pin_1, motor_pin_2, motor_pin_3, motor_pin_4);
    this->steps_per_degree = max(number_of_steps, 0) / 360.0;
}

Stepper::Stepper(int number_of_steps, int motor_pin_1, int motor_pin_2, int motor_pin_3, int motor_pin_4,
                 int motor_pin_5)
{
    this->stepper = &arduino::Stepper(number_of_steps, motor_pin_1, motor_pin_2, motor_pin_3, motor_pin_4, motor_pin_5);
    this->steps_per_degree = max(number_of_steps, 0) / 360.0;
}

void Stepper::set_max_acceleration(double max_acceleration)
{
    this->max_acceleration = max(max_acceleration, 0) * steps_per_degree;
}

void Stepper::set_max_speed(double max_speed)
{
    this->max_speed = max(max_speed, 0) * steps_per_degree;
}

void Stepper::set_target_position(double target_position)
{
    this->target_step = round(target_position * steps_per_degree);
}

void Stepper::tick()
{
    unsigned long now = micros();
    double seconds_since_tick = (now - last_tick_time) * 10e-6;
    double seconds_since_step = (now - last_step_time) * 10e-6;
    this->last_tick_time = now;

    long delta_steps = target_step - current_step;
    double target_speed = copysign(sqrt(2 * max_acceleration * abs(delta_steps)), delta_steps);

    double acceleration = copysign(max_acceleration, target_speed - current_speed);
    double delta_speed = acceleration * seconds_since_tick;

    double speed = current_speed + delta_speed;
    this->current_speed = constrain(speed, -max_speed, max_speed);

    if ((1 / current_speed) < seconds_since_step)
    {
        double direction = copysign(1, current_speed);
        stepper->step(direction);
        this->last_step_time = now;
        this->current_step += direction;
    }
}

} // namespace stepper

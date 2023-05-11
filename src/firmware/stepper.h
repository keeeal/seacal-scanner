#pragma once

namespace arduino
{
#include <Stepper.h>
}

namespace stepper
{
class Stepper
{
  public:
    Stepper(int number_of_steps, int motor_pin_1, int motor_pin_2);

    Stepper(int number_of_steps, int motor_pin_1, int motor_pin_2, int motor_pin_3, int motor_pin_4);

    Stepper(int number_of_steps, int motor_pin_1, int motor_pin_2, int motor_pin_3, int motor_pin_4, int motor_pin_5);

    // Set the acceleration in degrees per second per second.
    void set_max_acceleration(double max_acceleration);

    // Set the maximum speed in degrees per second.
    void set_max_speed(double speed);

    // Set the target position in degrees.
    void set_target_position(double position);

    void tick();

  private:
    arduino::Stepper* stepper;

    // The number of steps per degree of rotation.
    int steps_per_degree;

    // The motor acceleration in steps per second per second.
    double max_acceleration;

    // The highest motor speed permitted in steps per second.
    double max_speed;

    // The current speed of the motor in steps per second.
    double current_speed;

    // The step number the motor is currently at.
    long current_step;

    // The step number the motor will move to.
    long target_step;

    // The last time the motor moved in microseconds.
    unsigned long last_step_time;

    //
    unsigned long last_tick_time;
};
}

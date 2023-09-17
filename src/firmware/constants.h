#pragma once

#define ARM_STEP_PIN 10
#define ARM_DIR_PIN 11
#define ARM_DIR_UP 1 // 1 or -1
#define BASE_STEP_PIN 7
#define BASE_DIR_PIN 9
#define BASE_STEPS 2333 // Steps per revolution

#define ENABLE_PIN 0
#define RESET_PIN 4
#define MS1_PIN 1
#define MS2_PIN 2
#define MS3_PIN 3

#define TOP_LIMIT_PIN 14
#define BOTTOM_LIMIT_PIN 15
#define START_BUTTON_PIN 16
#define STOP_BUTTON_PIN 19

#define HOMING_SPEED_COARSE 200 // Steps per second
#define HOMING_SPEED_FINE 50    // Steps per second
#define HOMING_RETRACT_STEPS 25 // Steps

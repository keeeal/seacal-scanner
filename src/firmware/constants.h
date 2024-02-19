#pragma once

#define ARM_STEP_PIN 8
#define ARM_DIR_PIN 9
#define BASE_STEP_PIN 10
#define BASE_DIR_PIN 11
#define FAN_PIN 12
#define CAMERA_PIN 13

#define ENABLE_PIN 0
#define RESET_PIN 4
#define MS1_PIN 1
#define MS2_PIN 2
#define MS3_PIN 3

#define TOP_LIMIT_PIN PIN_A0
#define BOTTOM_LIMIT_PIN PIN_A1
#define START_BUTTON_PIN PIN_A2
#define STOP_BUTTON_PIN PIN_A5

// Global settings
#define ARM_UP_DIR 1              // 1 or -1
#define NUM_BASE_STEPS 74656      // Steps per base rotation
#define MAX_ARM_SPEED 4000        // Steps per second
#define MAX_ARM_ACCELERATION 4000 // Steps per second per second
#define MAX_BASE_SPEED 2000       // Steps per second
#define MAX_BASE_ACCELERATION 500 // Steps per second per second

// Homing settings
#define HOMING_SPEED_COARSE 3000 // Steps per second
#define HOMING_SPEED_FINE 200    // Steps per second
#define HOMING_RETRACT_STEPS 300 // Steps

// Scan settings
#define NUM_ARM_POSITIONS 32
#define NUM_BASE_POSITIONS 32

#pragma once

#define ARM_STEP_PIN 10
#define ARM_DIR_PIN 11
#define BASE_STEP_PIN 7
#define BASE_DIR_PIN 9

#define ENABLE_PIN 0
#define RESET_PIN 4
#define MS1_PIN 1
#define MS2_PIN 2
#define MS3_PIN 3

#define TOP_LIMIT_PIN 14
#define BOTTOM_LIMIT_PIN 15
#define START_BUTTON_PIN 16
#define STOP_BUTTON_PIN 19

// Global settings
#define ARM_DIR_UP 1        // 1 or -1
#define NUM_BASE_STEPS 2333 // Steps per base rotation

// Homing settings
#define HOMING_SPEED_COARSE 200 // Steps per second
#define HOMING_SPEED_FINE 50    // Steps per second
#define HOMING_RETRACT_STEPS 25 // Steps

// Scan settings
#define NUM_BASE_ROTATIONS 3
#define NUM_BASE_POSITIONS 8

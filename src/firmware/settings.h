#pragma once

#include <math.h>

// Output pins
#define ARM_STEP_PIN D8
#define ARM_DIR_PIN D9
#define BASE_STEP_PIN D10
#define BASE_DIR_PIN D11
#define FAN_PIN D12
#define CAMERA_PIN D13
#define GREEN_LED_PIN D6
#define RED_LED_PIN D7
#define ENABLE_PIN D0
#define RESET_PIN D4
#define MS1_PIN D1
#define MS2_PIN D2
#define MS3_PIN D3

// Input pins
#define TOP_LIMIT_PIN A0
#define BOTTOM_LIMIT_PIN A1
#define START_BUTTON_PIN A2
#define STOP_BUTTON_PIN A3

// Global settings
#define NUM_BASE_STEPS 74666 // Steps per base rotation
#define INIT_BASE_SPEED 8192 // Steps per second
#define INIT_ARM_SPEED 8192  // Steps per second

// Homing settings
#define HOMING_SPEED_COARSE 8192  // Steps per second
#define HOMING_SPEED_FINE 256     // Steps per second
#define HOMING_RETRACT_STEPS 1024 // Steps

// Scan settings
#define MIN_ARM_ANGLE M_PI_4 // radians
#define MAX_ARM_ANGLE M_PI   // radians
#define NUM_REVOLUTIONS 5
#define NUM_PHOTOS 100

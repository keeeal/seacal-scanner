// Define the stepper motor interface pins
#define COIL1_PIN 8
#define COIL2_PIN 9
#define COIL3_PIN 10
#define COIL4_PIN 11

void setup() {
  // Set the pins as outputs
  pinMode(COIL1_PIN, OUTPUT);
  pinMode(COIL2_PIN, OUTPUT);
  pinMode(COIL3_PIN, OUTPUT);
  pinMode(COIL4_PIN, OUTPUT);
}

void step(int step_number) {
  switch (step_number) {
    case 0:
      digitalWrite(COIL1_PIN, HIGH);
      digitalWrite(COIL2_PIN, LOW);
      digitalWrite(COIL3_PIN, LOW);
      digitalWrite(COIL4_PIN, HIGH);
      break;
    case 1:
      digitalWrite(COIL1_PIN, LOW);
      digitalWrite(COIL2_PIN, HIGH);
      digitalWrite(COIL3_PIN, LOW);
      digitalWrite(COIL4_PIN, HIGH);
      break;
    case 2:
      digitalWrite(COIL1_PIN, LOW);
      digitalWrite(COIL2_PIN, HIGH);
      digitalWrite(COIL3_PIN, HIGH);
      digitalWrite(COIL4_PIN, LOW);
      break;
    case 3:
      digitalWrite(COIL1_PIN, HIGH);
      digitalWrite(COIL2_PIN, LOW);
      digitalWrite(COIL3_PIN, HIGH);
      digitalWrite(COIL4_PIN, LOW);
      break;
  }
}

void loop() {
  // Move the stepper motor forward
  for (int i = 0; i < 200; i++) {
    step(i%4);
    delay(10);
  }
  
  // Wait for a second
  delay(1000);
  
  // Move the stepper motor backward
  for (int i = 199; i >= 0; i--) {
    step(i%4);
    delay(10);
  }
  
  //Wait for a second
  delay(1000);
}

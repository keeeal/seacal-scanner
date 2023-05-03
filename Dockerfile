FROM alpine:latest

RUN apk update
RUN apk --no-cache add \
    clang-extra-tools \
    curl \
    gcompat

# https://arduino.github.io/arduino-cli/latest/installation/#use-the-install-script
RUN curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh | sh
RUN arduino-cli core install arduino:avr

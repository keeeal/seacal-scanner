FROM alpine:latest

RUN apk update && apk --no-cache add \
    curl \
    gcompat

RUN curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh | sh
RUN arduino-cli core install arduino:avr

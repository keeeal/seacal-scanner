FROM alpine:latest

RUN apk update
RUN apk --no-cache add \
    clang-extra-tools

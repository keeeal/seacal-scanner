FROM ghcr.io/keeeal/openscad-format:latest

RUN apk update && apk --no-cache add \
    black

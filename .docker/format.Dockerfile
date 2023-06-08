FROM alpine:latest

RUN apk update
RUN apk --no-cache add \
    clang-extra-tools

COPY scripts/openscad-format.sh /
RUN ["chmod", "+x", "/openscad-format.sh"]

COPY .clang-format /

FROM python:alpine

RUN apk update && apk --no-cache add \
    clang-extra-tools

COPY scripts/openscad-format.sh /
RUN chmod +x /openscad-format.sh

COPY .clang-format /

RUN pip --no-cache-dir install --upgrade \
    black

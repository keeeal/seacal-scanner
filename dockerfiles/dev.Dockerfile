FROM ghcr.io/keeeal/openscad-format:latest

RUN apk update && apk --no-cache add \
    python3

RUN python -m ensurepip
RUN pip3 --no-cache-dir install --upgrade pip && \
    pip3 --no-cache-dir install \
    black \
    isort \
    pytest

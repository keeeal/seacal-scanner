FROM python:alpine

RUN apk --no-cache update && \
    apk --no-cache add \
    npm

RUN npm install --global openscad-format

RUN pip --no-cache-dir install --upgrade pip && \
    pip --no-cache-dir install \
    black \
    isort \
    pytest

COPY .clang-format /

FROM python:alpine

RUN pip --no-cache-dir install --upgrade pip && \
    pip --no-cache-dir install \
    black \
    isort \
    pytest

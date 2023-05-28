FROM python:latest

RUN pip --no-cache-dir install --upgrade \
    pip \
    pytest

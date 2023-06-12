FROM python:alpine

RUN pip --no-cache-dir install --upgrade \
    pip \
    pytest \
    pyyaml

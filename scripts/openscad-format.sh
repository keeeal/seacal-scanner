#!/bin/sh

for arg in "$@"
do
    if [ "${arg:${#arg}-5}" = ".scad" ]; then
        sed -E 's/^(use|include) *<.*>/\/\/ &/' -i $arg
    fi
done

clang-format "$@"
code=$?

for arg in "$@"
do
    if [ "${arg:${#arg}-5}" = ".scad" ]; then
        sed -E '/^\/\/ (use|include)/s/^\/\/ (.*)/\1/' -i $arg
    fi
done

exit $code

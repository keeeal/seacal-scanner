#!/usr/bin/env bash
set -e

min_angle=-45
max_angle=90
num_frames=10

for ((frame = 0; frame < num_frames; frame++)); do
    angle=$(awk \
        -v frame="$frame" \
        -v frames="$num_frames" \
        -v min="$min_angle" \
        -v max="$max_angle" \
        'BEGIN {
            pi = atan2(0, -1)
            theta = frame * pi / (frames - 1)
            eased = (1 - cos(theta)) / 2
            printf "%.2f", min + (max - min) * eased
        }')
    ARM_ANGLE="$angle" uv run -m cad export --part main --format obj
    mv parts/main-1.obj parts/frame-$frame.obj
done

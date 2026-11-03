import importlib
import os
from dataclasses import dataclass
from pathlib import Path

import numpy as np

import cad
import cad.frame
import cad.main
from cad.__main__ import view


@dataclass(frozen=True)
class Keyframe:
    """A pose; frame_duration is the number of frames to transition into it."""

    frame_duration: int
    arm_angle: float
    camera_position: tuple[float, float, float]


KEYFRAMES = [
    # Keyframe(0, 0, (500.0, 0.0, 110.0)),
    # Keyframe(10, 10, (500.0, 0.0, 110.0)),
    # Keyframe(40, -20, (500.0, 0.0, 110.0)),
    # Keyframe(90, 30, (500.0, 0.0, 110.0)),
    # Keyframe(160, -40, (500.0, 0.0, 110.0)),
    # Keyframe(180, -40, (500.0, 0.0, 110.0)),
    # Keyframe(210, -40, (500.0, -500.0, 500.0)),
    # Keyframe(230, -40, (500.0, -500.0, 500.0)),
    # Keyframe(300, 90, (300.0, 0.0, 110.0)),
    # Keyframe(160, -40, (500.0, 0.0, 110.0)),
    Keyframe(0, 0, (500.0, 0.0, 110.0)),
    Keyframe(20, -40, (500.0, 0.0, 110.0)),
    Keyframe(20, -40, (500.0, -500.0, 500.0)),
    Keyframe(20, -40, (500.0, -500.0, 500.0)),
    Keyframe(20, 90, (300.0, 0.0, 110.0)),
]


def camera_to_spherical(position: tuple[float, float, float]) -> np.ndarray:
    """Convert an origin-centered Cartesian point to (radius, polar, azimuth)."""
    x, y, z = position
    radius = np.linalg.norm(position)
    if radius == 0:
        raise ValueError("Camera keyframe positions must be away from the origin")
    return np.array((radius, np.arccos(z / radius), np.arctan2(y, x)))


def camera_to_cartesian(
    position: tuple[float, float, float],
) -> tuple[float, float, float]:
    """Convert (radius, polar, azimuth) to Cartesian Python floats."""
    radius, polar, azimuth = position
    return (
        float(radius * np.sin(polar) * np.cos(azimuth)),
        float(radius * np.sin(polar) * np.sin(azimuth)),
        float(radius * np.cos(polar)),
    )


def eased_keyframes(keyframes: list[Keyframe]) -> tuple[np.ndarray, np.ndarray]:
    """Ease arm angle and spherical camera coordinates between keyframes."""
    if len(keyframes) < 2:
        raise ValueError("At least two keyframes are required")
    if keyframes[0].frame_duration != 0:
        raise ValueError("The initial keyframe must have a frame duration of 0")
    if any(keyframe.frame_duration <= 0 for keyframe in keyframes[1:]):
        raise ValueError("Transition keyframe durations must be positive")

    num_frames = 1 + sum(keyframe.frame_duration for keyframe in keyframes[1:])
    angles = np.empty(num_frames)
    spherical_camera_positions = np.empty((num_frames, 3))
    spherical_positions = [
        camera_to_spherical(keyframe.camera_position) for keyframe in keyframes
    ]

    frame_start = 0
    for index, (start_keyframe, end_keyframe) in enumerate(
        zip(keyframes, keyframes[1:]),
    ):
        frame_end = frame_start + end_keyframe.frame_duration
        segment = np.arange(frame_start, frame_end + 1)
        progress = np.linspace(0, 1, end_keyframe.frame_duration + 1)
        eased = (1 - np.cos(np.pi * progress)) / 2
        angles[segment] = (
            start_keyframe.arm_angle
            + (end_keyframe.arm_angle - start_keyframe.arm_angle) * eased
        )

        start_camera = spherical_positions[index]
        end_camera = spherical_positions[index + 1].copy()
        azimuth_delta = (end_camera[2] - start_camera[2] + np.pi) % (2 * np.pi) - np.pi
        end_camera[2] = start_camera[2] + azimuth_delta
        spherical = start_camera + eased[:, None] * (end_camera - start_camera)
        spherical_camera_positions[segment] = spherical
        frame_start = frame_end

    return angles, spherical_camera_positions


angles, spherical_camera_positions = eased_keyframes(KEYFRAMES)


for angle, camera_position_spherical in zip(angles, spherical_camera_positions):
    os.environ["ARM_ANGLE"] = f"{angle:.2f}"
    importlib.reload(cad.frame)
    importlib.reload(cad)
    importlib.reload(cad.main)

    view(
        config_path=Path("src/cad/config.yaml"),
        part_name="main",
        position=camera_to_cartesian(tuple(camera_position_spherical)),
        # target=(0.0, 0.0, 110.0),
        screenshot=True,
    )

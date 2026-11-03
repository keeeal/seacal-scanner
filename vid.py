from concurrent.futures import ProcessPoolExecutor
from dataclasses import dataclass
from functools import cache
from pathlib import Path

import numpy as np
from build123d import export_obj

from cad.main import MainAssembly


@dataclass(frozen=True)
class Keyframe:
    """An arm pose; frame_duration is the number of frames to transition into it."""

    frame_duration: int
    arm_angle: float


KEYFRAMES = [
    Keyframe(0, 0),
    Keyframe(10, 10),
    Keyframe(30, -20),
    Keyframe(50, 30),
    Keyframe(70, -40),
    Keyframe(130, 90),
]


def eased_keyframes(keyframes: list[Keyframe]) -> np.ndarray:
    """Ease arm angle between keyframes."""
    if len(keyframes) < 2:
        raise ValueError("At least two keyframes are required")
    if keyframes[0].frame_duration != 0:
        raise ValueError("The initial keyframe must have a frame duration of 0")
    if any(keyframe.frame_duration <= 0 for keyframe in keyframes[1:]):
        raise ValueError("Transition keyframe durations must be positive")

    num_frames = 1 + sum(keyframe.frame_duration for keyframe in keyframes[1:])
    angles = np.empty(num_frames)

    frame_start = 0
    for start_keyframe, end_keyframe in zip(keyframes, keyframes[1:]):
        frame_end = frame_start + end_keyframe.frame_duration
        segment = np.arange(frame_start, frame_end + 1)
        progress = np.linspace(0, 1, end_keyframe.frame_duration + 1)
        eased = (1 - np.cos(np.pi * progress)) / 2
        angles[segment] = (
            start_keyframe.arm_angle
            + (end_keyframe.arm_angle - start_keyframe.arm_angle) * eased
        )
        frame_start = frame_end

    return angles


@cache
def build_assembly_cached(angle: float) -> MainAssembly:
    return MainAssembly(arm_angle=angle)


def build_assembly(angle: float) -> MainAssembly:
    if angle.is_integer():
        return build_assembly_cached(angle)
    return MainAssembly(arm_angle=angle)


def export_frame(frame_job: tuple[int, float, Path]) -> None:
    frame_index, angle, output_dir = frame_job
    assembly = build_assembly(angle)
    assembly = assembly.scale(0.01)
    export_obj(assembly, output_dir / f"main-{frame_index:04d}.obj")


if __name__ == "__main__":
    angles = eased_keyframes(KEYFRAMES)
    output_dir = Path("frames")
    output_dir.mkdir(parents=True, exist_ok=True)
    frame_jobs = [
        (frame_index, float(angle), output_dir)
        for frame_index, angle in enumerate(angles)
    ]

    with ProcessPoolExecutor() as executor:
        list(executor.map(export_frame, frame_jobs, chunksize=1))

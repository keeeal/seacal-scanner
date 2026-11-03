from build123d import *
from build123d.topology.shape_core import Shape

from cad.frame import FrameAssembly


class MainAssembly(Compound):
    def __init__(
        self,
        *,
        frame_size_x: float = 200.0,
        frame_size_y: float = 150.0,
        arm_length: float | None = None,
        arm_angle: float = 0.0,
        arm_num_teeth: int = 80,
        motor_num_teeth: int = 20,
        label: str = "",
        color: Color | None = None,
        parent: Compound | None = None,
    ):
        children: list[Shape] = []

        frame = FrameAssembly(
            frame_size_x=frame_size_x,
            frame_size_y=frame_size_y,
            arm_length=arm_length,
            arm_angle=arm_angle,
            arm_num_teeth=arm_num_teeth,
            motor_num_teeth=motor_num_teeth,
        )
        frame.label = "frame"
        children.append(frame)

        super().__init__(
            label=label,
            color=color,
            parent=parent,
            children=children,
        )

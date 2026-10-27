from build123d import *
from build123d.topology.shape_core import Shape

from cad.frame import FrameAssembly


class MainAssembly(Compound):
    def __init__(
        self,
        *,
        label: str = "",
        color: Color | None = None,
        parent: Compound | None = None,
    ):
        children: list[Shape] = []

        frame = FrameAssembly()
        frame.label = "frame"
        children.append(frame)

        super().__init__(
            label=label,
            color=color,
            parent=parent,
            children=children,
        )

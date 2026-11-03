from bd_warehouse.thread import IsoThread
from build123d import *

from cad.utils.env import getenv_bool

SIMPLE = getenv_bool("SIMPLE")
EPS = 1e-3


class HexScrew(BasePartObject):
    def __init__(
        self,
        length: float = 8.0,
        *,
        rotation: RotationLike = (0, 0, 0),
        align: Align | tuple[Align, Align, Align] | None = None,
        mode: Mode = Mode.ADD,
    ) -> None:
        with BuildPart() as main:
            with BuildSketch():
                Circle(4.5)
            extrude(amount=-1.5)
            chamfer(main.edges().group_by(Axis.Z)[0], 0.3, 0.75)
            if SIMPLE:
                with BuildSketch():
                    Circle(2.5)
                extrude(amount=length)
                chamfer(main.edges().group_by(Axis.Z)[-1], 0.5)
            else:
                with BuildSketch():
                    Circle(2.5)
                extrude(amount=length / 3)
                chamfer(main.edges().group_by(Axis.Z)[-1], 0.5)
                thread = IsoThread(
                    major_diameter=5.0 - EPS,
                    pitch=1.0,
                    length=length,
                    end_finishes=("raw", "chamfer"),
                )
                with BuildSketch():
                    Circle(thread.min_radius)
                extrude(amount=length)
            with BuildSketch(main.faces().group_by(Axis.Z)[0]):
                RegularPolygon(1.5, 6)
            extrude(amount=-3, mode=Mode.SUBTRACT)

        super().__init__(main.part, rotation=rotation, align=align, mode=mode)


class SlidingTNut(BasePartObject):
    def __init__(
        self,
        hole_radius: float = 2.6,
        *,
        rotation: RotationLike = (0, 0, 0),
        align: Align | tuple[Align, Align, Align] | None = None,
        mode: Mode = Mode.ADD,
    ):
        with BuildPart() as main:
            with BuildSketch(Plane.YZ):
                with BuildLine():
                    Polyline(
                        (0, 4.5),
                        (3.1, 4.5),
                        (3.1, 3),
                        (4.75, 3),
                        (4.75, 2),
                        (2.75, 0),
                        (0, 0),
                    )
                    mirror(about=Plane.YZ)
                make_face()
            extrude(amount=4.75, both=True)
            chamfer(main.edges().filter_by(Axis.X, reverse=True), length=0.5)
            Hole(hole_radius)

        super().__init__(main.part, rotation=rotation, align=align, mode=mode)

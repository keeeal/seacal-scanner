from copy import copy
from math import cos, pi, radians, sqrt

from bd_warehouse.open_builds import StepperMotor, VSlotLinearRail
from build123d import *
from build123d.topology.shape_core import Shape

from cad.hardware import HexScrew, SlidingTNut
from cad.utils.color import unset_color
from cad.utils.hull import Hull

SCREW = HexScrew()
NUT = SlidingTNut()


class EndStop(BasePartObject):
    def __init__(
        self,
        *,
        rotation: RotationLike = (0, 0, 0),
        align: Align | tuple[Align, Align, Align] | None = None,
        mode: Mode = Mode.ADD,
    ) -> None:
        with BuildPart() as main:
            with BuildSketch(Plane.XZ):
                with Locations((5, 0)):
                    Rectangle(7.5, 1, align=Align.MIN)
                with Locations((6, 7)):
                    Circle(1)
                with Locations((9, 5)):
                    Circle(3)
                make_hull()
            revolve()
            with BuildSketch():
                Circle(6)
                Circle(2.75, mode=Mode.SUBTRACT)
            extrude(amount=4)

        super().__init__(main.part, rotation=rotation, align=align, mode=mode)


class CornerBracket(BasePartObject):
    def __init__(
        self,
        *,
        rotation: RotationLike = (0, 0, 0),
        align: Align | tuple[Align, Align, Align] | None = None,
        mode: Mode = Mode.ADD,
    ) -> None:
        with BuildPart() as main:
            with BuildSketch():
                Rectangle(20, 14.5, align=(Align.MIN, Align.CENTER))
                with Locations((15, 0)):
                    SlotOverall(9, 5.5, 90, mode=Mode.SUBTRACT)
            extrude(amount=3)
            with BuildSketch(Plane.YZ):
                Rectangle(14.5, 20, align=(Align.CENTER, Align.MIN))
                with Locations((0, 10)):
                    SlotOverall(9, 5.5, mode=Mode.SUBTRACT)
            extrude(amount=3)

        super().__init__(main.part, rotation=rotation, align=align, mode=mode)


class FootCover(BasePartObject):
    def __init__(
        self,
        *,
        with_foot: bool = False,
        mirrored: bool = False,
        rotation: RotationLike = (0, 0, 0),
        align: Align | tuple[Align, Align, Align] | None = None,
        mode: Mode = Mode.ADD,
    ) -> None:
        with BuildSketch() as major:
            Rectangle(30, 30)
            chamfer(major.vertices(), length=3.5)

        with BuildSketch() as minor:
            Rectangle(23, 23)

        with BuildPart() as arm:
            Hull(
                major.sketch.vertices()
                + minor.sketch.translate((0, 0, 18.5)).vertices(),
            )

        with BuildPart() as arm_long:
            Hull(
                major.sketch.vertices()
                + minor.sketch.translate((0, 0, 28.5)).vertices(),
            )

        with BuildPart() as main:
            Box(30, 30, 30)
            chamfer(main.edges(), length=3.5)
            with Locations(Location((0, 11.5, 0), (-90, 0, 0))):
                insert(arm)
            with Locations(Location((11.5, 0, 0), (0, 90, 0))):
                insert(arm_long)
            Hull(
                major.sketch.translate((0, 0, 11.5)).vertices()
                + major.sketch.translate((-11.5, 0, 0))
                .rotate(Axis.Y, 30)
                .translate((11.5, 0, 11.5))
                .vertices(),
                mode=Mode.ADD,
            )
            insert(
                arm.part.translate((-11.5, 0, 0))
                .rotate(Axis.Y, 30)
                .translate((11.5, 0, 11.5)),
            )
            insert(
                arm.part.translate((-11.5, 0, 0))
                .rotate(Axis.Y, 30)
                .translate((11.5, 0, 11.5)),
            )

            top = main.faces().group_by(Axis.Z)[-1][0]
            with BuildSketch(top):
                Rectangle(20, 20)
            extrude(amount=-19, mode=Mode.SUBTRACT)
            with BuildSketch(top.offset(-18.5)):
                Circle(2.75)
            extrude(amount=-10, mode=Mode.SUBTRACT)
            with BuildSketch(top.offset(-22)):
                Circle(5)
            extrude(amount=-10, mode=Mode.SUBTRACT)

            side = main.faces().group_by(Axis.Y)[-1][0]
            with BuildSketch(side.offset(-45)):
                with BuildLine():
                    Polyline(
                        (-11.5, -11.5),
                        (-11.5, 11.5),
                        (-30, 6.5),
                        (-30, -6.5),
                        close=True,
                    )
                make_face()
            extrude(amount=5)
            chamfer(
                main.edges(Select.LAST).group_by(Axis.Y)[0].group_by(Axis.X)[-1],
                length=2.2,
            )
            with BuildSketch(side.offset(-40)), Locations((0, 0), (-20, 0)):
                Circle(2.75)
            extrude(amount=-10, mode=Mode.SUBTRACT)
            with BuildSketch(side.offset(-43)), Locations((0, 0), (-20, 0)):
                Circle(5)
            extrude(amount=-10, mode=Mode.SUBTRACT)
            chamfer(main.edges(Select.LAST).group_by(Axis.Y)[0], length=0.5)

            with Locations((-10, -10, 0)):
                Box(
                    100,
                    100,
                    20,
                    align=(Align.MIN, Align.MIN, Align.CENTER),
                    mode=Mode.SUBTRACT,
                )

            if with_foot:
                base = Plane.XY.offset(-15)
                with BuildSketch(base):
                    Circle(14.2)
                extrude(amount=5)
                with BuildSketch(base):
                    Circle(13)
                extrude(amount=5, mode=Mode.SUBTRACT)

            with BuildSketch(top.offset(-33)), Locations((2.5, 0, 0)):
                Circle(3)
            extrude(until=Until.FIRST, mode=Mode.SUBTRACT)
            chamfer(main.edges(Select.LAST).group_by(Axis.X)[0], length=0.5)
            if mirrored:
                mirror(about=Plane.YZ, mode=Mode.REPLACE)

        super().__init__(main.part, rotation=rotation, align=align, mode=mode)


class FootAssembly(Compound):
    def __init__(
        self,
        *,
        mirrored: bool = False,
        label: str = "",
        color: Color | None = None,
        parent: Compound | None = None,
    ):
        children: list[Shape] = []

        cover = FootCover(with_foot=True, mirrored=mirrored)
        cover.label = "foot-cover"
        children.append(cover)

        bracket = CornerBracket().move(Location((10, 10, 0), (-90, 0, 0)))
        if mirrored:
            bracket = bracket.mirror(Plane.YZ)
        bracket.label = "corner-bracket"
        children.append(bracket)

        screws = [
            copy(SCREW).move(Location((0, 0, -14), (0, 0, 0))),
            copy(SCREW).move(Location((0, -13, 0), (-90, 0, 0))),
        ]
        nuts = [
            copy(NUT).move(Location((0, 0, -5), (180, 0, 90))),
        ]
        if mirrored:
            screws.extend(
                [
                    copy(SCREW).move(Location((-20, -13, 0), (-90, 0, 0))),
                    copy(SCREW).move(Location((-25, 13, 0), (90, 0, 0))),
                    copy(SCREW).move(Location((-13, 20, 0), (0, 90, 0))),
                    copy(SCREW)
                    .translate((0, 0, -0.5))
                    .move(Location((0, 0, 14.5), (0, -30, 0))),
                ],
            )
            nuts.extend(
                [
                    copy(NUT).move(Location((-20, -5, 0), (90, 0, 0))),
                    copy(NUT).move(Location((-25, 5, 0), (-90, 0, 0))),
                    copy(NUT).move(Location((-5, 20, 0), (0, -90, 90))),
                ],
            )
        else:
            screws.extend(
                [
                    copy(SCREW).move(Location((20, -13, 0), (-90, 0, 0))),
                    copy(SCREW).move(Location((25, 13, 0), (90, 0, 0))),
                    copy(SCREW).move(Location((13, 20, 0), (0, -90, 0))),
                    copy(SCREW)
                    .translate((0, 0, -0.5))
                    .move(Location((0, 0, 14.5), (0, 30, 0))),
                ],
            )
            nuts.extend(
                [
                    copy(NUT).move(Location((20, -5, 0), (90, 0, 0))),
                    copy(NUT).move(Location((25, 5, 0), (-90, 0, 0))),
                    copy(NUT).move(Location((5, 20, 0), (0, 90, 90))),
                ],
            )
        for index, part in enumerate(screws):
            part.label = f"screw-{index}"
        children.extend(screws)
        for index, part in enumerate(nuts):
            part.label = f"nut-{index}"
        children.extend(nuts)

        end_stop = EndStop().move(Location((0, 0, -10), (180, 0, 0)))
        end_stop.label = "end-stop"
        children.append(end_stop)

        super().__init__(
            label=label,
            color=color,
            parent=parent,
            children=children,
        )


class ApexCover(BasePartObject):
    def __init__(
        self,
        *,
        rotation: RotationLike = (0, 0, 0),
        align: Align | tuple[Align, Align, Align] | None = None,
        mode: Mode = Mode.ADD,
    ) -> None:
        with BuildSketch() as major:
            Rectangle(30, 30)
            chamfer(major.vertices(), length=3.5)

        with BuildSketch() as minor:
            Rectangle(23, 23)

        with BuildPart() as arm:
            Hull(
                major.sketch.vertices()
                + minor.sketch.translate((0, 0, 18.5)).vertices(),
            )

        with BuildPart() as core:
            Box(30, 30, 30)
            chamfer(core.edges(), length=3.5)

        with BuildPart() as main:
            Hull(
                core.part.vertices()
                + major.sketch.translate((0, 0, -26)).rotate(Axis.X, -30).vertices(),
                mode=Mode.ADD,
            )
            Hull(
                core.part.vertices()
                + major.sketch.translate((0, 0, -26)).rotate(Axis.X, +30).vertices(),
                mode=Mode.ADD,
            )
            insert(
                arm.part.rotate(Axis.X, 180).translate((0, 0, -26)).rotate(Axis.X, -30),
            )
            insert(
                arm.part.rotate(Axis.X, 180).translate((0, 0, -26)).rotate(Axis.X, +30),
            )
            faces = main.faces().group_by(Axis.Z)[0]
            with BuildSketch(faces):
                Rectangle(20, 20)
            extrude(amount=-27, mode=Mode.SUBTRACT)
            with BuildSketch(faces):
                Circle(2.75)
            extrude(until=Until.FIRST, mode=Mode.SUBTRACT)
            for face in faces:
                with BuildSketch(face.offset(-30)):
                    Circle(5)
                extrude(amount=-100, mode=Mode.SUBTRACT)
                chamfer(main.edges(Select.LAST).group_by(Axis.Z)[-2:], length=0.5)
            with BuildSketch(Plane.YZ), Locations((0, -6.5)):
                Circle(6.25)
            extrude(until=Until.LAST, both=True, mode=Mode.SUBTRACT)

        super().__init__(main.part, rotation=rotation, align=align, mode=mode)


class Pulley(BasePartObject):
    def __init__(
        self,
        num_teeth: int,
        pitch: float = 2,
        height: float = 7,
        axle_radius: float = 0,
        *,
        rotation: RotationLike = (0, 0, 0),
        align: Align | tuple[Align, Align, Align] | None = None,
        mode: Mode = Mode.ADD,
    ) -> None:
        self.radius = num_teeth * pitch / (2 * pi)

        with BuildSketch() as profile:
            Circle(self.radius)
            with PolarLocations(self.radius, num_teeth):
                SlotOverall(pitch, 7 * pitch / 10, mode=Mode.SUBTRACT)

        with BuildPart() as main:
            with BuildSketch(Plane.XY.offset(2.5)):
                insert(profile)
            extrude(amount=height)
            with BuildSketch():
                Circle(self.radius + 3)
            extrude(amount=2.5)
            chamfer(main.edges(Select.LAST).group_by(Axis.Z)[-1], length=1)
            with BuildSketch(Plane.XY.offset(height + 2.5)):
                Circle(self.radius + 3)
            extrude(amount=2.5)
            chamfer(main.edges(Select.LAST).group_by(Axis.Z)[0], length=1)
            if axle_radius > 0:
                with BuildSketch():
                    Circle(axle_radius)
                extrude(until=Until.LAST, mode=Mode.SUBTRACT)

        super().__init__(main.part, rotation=rotation, align=align, mode=mode)


class Belt(BasePartObject):
    def __init__(
        self,
        pulley_a_location: tuple[float, float],
        pulley_a_radius: float,
        pulley_b_location: tuple[float, float],
        pulley_b_radius: float,
        height: float = 5,
        offset: float = 0,
        *,
        rotation: RotationLike = (0, 0, 0),
        align: Align | tuple[Align, Align, Align] | None = None,
        mode: Mode = Mode.ADD,
    ):
        with BuildSketch() as inner:
            with Locations(tuple(pulley_a_location)):
                Circle(pulley_a_radius)
            with Locations(tuple(pulley_b_location)):
                Circle(pulley_b_radius)
            make_hull()

        with BuildSketch() as outer:
            with Locations(tuple(pulley_a_location)):
                Circle(pulley_a_radius + 0.63)
            with Locations(tuple(pulley_b_location)):
                Circle(pulley_b_radius + 0.63)
            make_hull()

        path = inner.wire()

        with BuildSketch() as teeth:
            period = 2.0
            num_teeth = path.length // period
            for index in range(int(num_teeth)):
                fraction = (index * period + offset % period) / path.length
                location = Plane(path @ fraction, x_dir=path % fraction).location
                with Locations(location):
                    SlotOverall(1.5, 1.2, 90)
            insert(outer, mode=Mode.INTERSECT)

        with BuildPart() as main:
            with BuildSketch():
                insert(outer)
                insert(inner, mode=Mode.SUBTRACT)
                insert(teeth)
            extrude(amount=height)

        super().__init__(main.part, rotation=rotation, align=align, mode=mode)


class ArmCover(BasePartObject):
    def __init__(
        self,
        num_teeth: int | None = None,
        *,
        rotation: RotationLike = (0, 0, 0),
        align: Align | tuple[Align, Align, Align] | None = None,
        mode: Mode = Mode.ADD,
    ) -> None:
        with BuildSketch() as major:
            Rectangle(30, 30)
            chamfer(major.vertices(), length=3.5)

        with BuildSketch() as minor:
            Rectangle(23, 23)

        with BuildPart() as arm:
            Hull(
                major.sketch.vertices()
                + minor.sketch.translate((0, 0, 18.5)).vertices(),
            )

        with BuildPart() as main:
            Box(30, 30, 30)
            chamfer(main.edges(), length=3.5)
            with Locations(
                Location((0, -11.5, 0), (90, 0, 0)),
                Location((0, 11.5, 0), (-90, 0, 0)),
            ):
                insert(arm)
            with BuildSketch(Plane.XZ):
                Rectangle(20, 20)
            extrude(until=Until.LAST, both=True, mode=Mode.SUBTRACT)

            if num_teeth is not None:
                with Locations((0, 0, -1)):
                    Box(100, 100, 30, mode=Mode.INTERSECT)
                with Locations((0, 0, 11.5)):
                    pulley = Pulley(num_teeth)
                self.pulley_radius = pulley.radius
            else:
                self.pulley_radius = None

            top = main.faces().group_by(Axis.Z)[-1][0]
            with BuildSketch(top.offset(-2.25)):
                Circle(9.25)
            extrude(until=Until.FIRST, mode=Mode.SUBTRACT)
            chamfer(main.edges(Select.LAST).group_by(Axis.Z)[0], length=1)
            with BuildSketch(top.offset(-2.25)):
                Circle(6.25)
            extrude(until=Until.LAST, mode=Mode.SUBTRACT)
            with BuildSketch(Plane.YZ):
                Circle(2.75)
            extrude(until=Until.LAST, both=True, mode=Mode.SUBTRACT)
            with BuildSketch(Plane.YZ.offset(-13)):
                Circle(5)
            extrude(amount=-10, mode=Mode.SUBTRACT)
            chamfer(main.edges(Select.LAST).group_by(Axis.X)[0], length=0.5)
            with BuildSketch(Plane.YZ.offset(+13)):
                Circle(5)
            extrude(amount=+10, mode=Mode.SUBTRACT)
            chamfer(main.edges(Select.LAST).group_by(Axis.X)[-1], length=0.5)

        super().__init__(main.part, rotation=rotation, align=align, mode=mode)


class AxlePin(BasePartObject):
    def __init__(
        self,
        *,
        rotation: RotationLike = (0, 0, 0),
        align: Align | tuple[Align, Align, Align] | None = None,
        mode: Mode = Mode.ADD,
    ) -> None:
        with BuildPart() as main:
            with BuildSketch():
                Circle(6)
            extrude(amount=32.75)
            with BuildSketch(main.faces().group_by(Axis.Z)[-1]):
                Circle(8.5)
            extrude(amount=5)
            chamfer(main.edges().group_by(Axis.Z)[-1], length=4.5, length2=2.5)
            Box(9.5, 100, 100, mode=Mode.INTERSECT)
            with BuildSketch(Plane.YZ) as profile:
                with BuildLine():
                    Polyline((0, 0), (-3, 37.75), (+3, 37.75), close=True)
                make_face()
                fillet(profile.vertices().group_by(Axis.Y)[0], radius=1)
            extrude(until=Until.LAST, both=True, mode=Mode.SUBTRACT)
            with BuildSketch():
                Circle(9)
                with Locations((5.25, 0)):
                    Rectangle(20, 20, mode=Mode.INTERSECT)
            extrude(amount=-2.5)

        super().__init__(main.part, rotation=rotation, align=align, mode=mode)


class ApexAssembly(Compound):
    def __init__(
        self,
        with_apex: bool = True,
        with_arm: bool = True,
        num_teeth: int | None = None,
        *,
        label: str = "",
        color: Color | None = None,
        parent: Compound | None = None,
    ):
        children: list[Shape] = []

        screws: list[HexScrew] = []
        nuts: list[SlidingTNut] = []

        if with_apex:
            apex = ApexCover().move(Location((0, 0, 6.5)))
            apex.label = "apex"
            children.append(apex)
            screws.extend(
                [
                    copy(SCREW).move(Location((0, +7, -5.5), (-150, 0, 0))),
                    copy(SCREW).move(Location((0, -7, -5.5), (+150, 0, 0))),
                ],
            )

        if with_arm:
            arm_offset = 30 if num_teeth is None else 38.5
            arm = ArmCover(num_teeth)
            arm.move(Location((arm_offset, 0, 0), (0, -90, 0)))
            arm.label = "arm"
            children.append(arm)
            self.pulley_radius = arm.pulley_radius

            axle = AxlePin().move(Location((17.5, 0, 0), (0, -90, 0)))
            axle.label = "axle"
            children.append(axle)
            screws.extend(
                [
                    copy(SCREW).move(Location((arm_offset, 0, -13), (0, 0, 0))),
                    copy(SCREW).move(Location((arm_offset, 0, +13), (180, 0, 0))),
                ],
            )
            nuts = [
                copy(NUT).move(Location((arm_offset, 0, -5), (180, 0, 90))),
                copy(NUT).move(Location((arm_offset, 0, +5), (0, 0, 90))),
            ]
        else:
            self.pulley_radius = None

        for index, part in enumerate(screws):
            part.label = f"screw-{index}"
        children.extend(screws)
        for index, part in enumerate(nuts):
            part.label = f"nut-{index}"
        children.extend(nuts)

        super().__init__(
            label=label,
            color=color,
            parent=parent,
            children=children,
        )


class CornerCover(BasePartObject):
    def __init__(
        self,
        *,
        mirrored: bool = False,
        rotation: RotationLike = (0, 0, 0),
        align: Align | tuple[Align, Align, Align] | None = None,
        mode: Mode = Mode.ADD,
    ) -> None:
        with BuildSketch() as major:
            Rectangle(30, 30)
            chamfer(major.vertices(), length=3.5)

        with BuildSketch() as minor:
            Rectangle(23, 23)

        with BuildPart() as arm:
            Hull(
                major.sketch.vertices()
                + minor.sketch.translate((0, 0, 18.5)).vertices(),
            )

        with BuildPart() as arm_long:
            Hull(
                major.sketch.vertices()
                + minor.sketch.translate((0, 0, 28.5)).vertices(),
            )

        with BuildPart() as main:
            Box(30, 30, 30)
            chamfer(main.edges(), length=3.5)
            with Locations(
                Location((11.5, 0, 0), (0, 90, 0)),
            ):
                insert(arm)
            with Locations(
                Location((0, 11.5, 0), (-90, 0, 0)),
            ):
                insert(arm_long)

            y = main.faces().group_by(Axis.Y)[-1][0]
            with BuildSketch(y), Locations((-2, 0)):
                Rectangle(24, 20)
            extrude(amount=-16, mode=Mode.SUBTRACT)
            with BuildSketch(y.offset(-16)):
                Circle(2.75)
            extrude(until=Until.FIRST, mode=Mode.SUBTRACT)
            with BuildSketch(y.offset(-19)):
                Circle(5)
            extrude(until=Until.FIRST, mode=Mode.SUBTRACT)
            chamfer(main.edges(Select.LAST).group_by(Axis.Y)[0], length=0.5)

            x = main.faces().group_by(Axis.X)[-1][0]
            with BuildSketch(x), Locations((0, -10)):
                Rectangle(20, 40)
            extrude(amount=-20, mode=Mode.SUBTRACT)
            with BuildSketch(x):
                Rectangle(20, 20)
            extrude(amount=-40, mode=Mode.SUBTRACT)
            with BuildSketch(x):
                Circle(2.75)
            extrude(until=Until.FIRST, mode=Mode.SUBTRACT)
            with BuildSketch(x.offset(-43)):
                Circle(5)
            extrude(until=Until.FIRST, mode=Mode.SUBTRACT)
            chamfer(main.edges(Select.LAST).group_by(Axis.X)[0], length=0.5)

            if mirrored:
                mirror(about=Plane.YZ, mode=Mode.REPLACE)

        super().__init__(main.part, rotation=rotation, align=align, mode=mode)


class CornerCover(BasePartObject):
    def __init__(
        self,
        *,
        mirrored: bool = False,
        rotation: RotationLike = (0, 0, 0),
        align: Align | tuple[Align, Align, Align] | None = None,
        mode: Mode = Mode.ADD,
    ) -> None:
        with BuildSketch() as major:
            Rectangle(30, 30)
            chamfer(major.vertices(), length=3.5)

        with BuildSketch() as minor:
            Rectangle(23, 23)

        with BuildPart() as arm:
            Hull(
                major.sketch.vertices()
                + minor.sketch.translate((0, 0, 18.5)).vertices(),
            )

        with BuildPart() as arm_long:
            Hull(
                major.sketch.vertices()
                + minor.sketch.translate((0, 0, 38.5)).vertices(),
            )

        with BuildPart() as main:
            Box(30, 30, 30)
            chamfer(main.edges(), length=3.5)
            with Locations(Location((11.5, 0, 0), (0, 90, 0))):
                insert(arm)
            with Locations(Location((0, 11.5, 0), (-90, 0, 0))):
                insert(arm_long)

            y = main.faces().group_by(Axis.Y)[-1][0]
            with BuildSketch(y), Locations((-2, 0)):
                Rectangle(24, 20)
            extrude(amount=-16 - 10, mode=Mode.SUBTRACT)
            with BuildSketch(y.offset(-16 - 10)):
                Circle(2.75)
            extrude(until=Until.FIRST, mode=Mode.SUBTRACT)
            with BuildSketch(y.offset(-19 - 10)):
                Circle(5)
            extrude(until=Until.FIRST, mode=Mode.SUBTRACT)
            chamfer(main.edges(Select.LAST).group_by(Axis.Y)[0], length=0.5)

            x = main.faces().group_by(Axis.X)[-1][0]
            with BuildSketch(x.offset(-45).rotate(Axis.X, 90)):
                with BuildLine():
                    Polyline(
                        (-11.5, -11.5),
                        (-11.5, 11.5),
                        (-45, 6.5),
                        (-45, -6.5),
                        close=True,
                    )
                make_face()
            extrude(amount=5)
            chamfer(
                main.edges(Select.LAST).group_by(Axis.X)[0].group_by(Axis.Y)[-1],
                length=3,
            )
            with BuildSketch(x), Locations((0, -10)):
                Rectangle(20, 40)
            extrude(amount=-20, mode=Mode.SUBTRACT)
            with BuildSketch(x):
                Rectangle(20, 20)
            extrude(amount=-40, mode=Mode.SUBTRACT)
            with BuildSketch(x), Locations((0, 0), (0, -35)):
                Circle(2.75)
            extrude(until=Until.FIRST, mode=Mode.SUBTRACT)
            with BuildSketch(x.offset(-43)), Locations((0, 0), (0, -35)):
                Circle(5)
            extrude(until=Until.FIRST, mode=Mode.SUBTRACT)
            chamfer(main.edges(Select.LAST).group_by(Axis.X)[0], length=0.5)

            if mirrored:
                mirror(about=Plane.YZ, mode=Mode.REPLACE)

        super().__init__(main.part, rotation=rotation, align=align, mode=mode)


class CornerAssembly(Compound):
    def __init__(
        self,
        *,
        mirrored: bool = False,
        label: str = "",
        color: Color | None = None,
        parent: Compound | None = None,
    ):
        children: list[Shape] = []

        cover = CornerCover(mirrored=mirrored)
        cover.label = "foot-cover"
        children.append(cover)

        screws = [
            copy(SCREW).move(Location((0, 21, 0), (-90, 0, 0))),
        ]
        nuts: list[SlidingTNut] = []
        if mirrored:
            screws.append(copy(SCREW).move(Location((+13, 0, 0), (0, -90, 0))))
            screws.append(copy(SCREW).move(Location((+13, 35, 0), (0, -90, 0))))
            nuts.append(copy(NUT).move(Location((+5, 35, 0), (0, 90, 90))))
        else:
            screws.append(copy(SCREW).move(Location((-13, 0, 0), (0, +90, 0))))
            screws.append(copy(SCREW).move(Location((-13, 35, 0), (0, +90, 0))))
            nuts.append(copy(NUT).move(Location((-5, 35, 0), (0, -90, 90))))
        for index, part in enumerate(screws):
            part.label = f"screw-{index}"
        children.extend(screws)
        for index, part in enumerate(nuts):
            part.label = f"nut-{index}"
        children.extend(nuts)

        super().__init__(
            label=label,
            color=color,
            parent=parent,
            children=children,
        )


class EndCover(BasePartObject):
    def __init__(
        self,
        *,
        rotation: RotationLike = (0, 0, 0),
        align: Align | tuple[Align, Align, Align] | None = None,
        mode: Mode = Mode.ADD,
    ) -> None:
        with BuildPart() as main:
            with BuildSketch():
                Rectangle(20, 20)
            extrude(amount=12)
            chamfer(main.edges().group_by(Axis.Z)[-1], length=3.5)
            with BuildSketch(Plane.YZ) as profile:
                with Locations((0, 7)):
                    Rectangle(12, 4)
                chamfer(profile.vertices().group_by(Axis.Y)[-1], length=2)
            extrude(until=Until.LAST, both=True, mode=Mode.SUBTRACT)
            chamfer(
                main.edges(Select.LAST).filter_by(Axis.Y).group_by(Axis.Z)[0],
                length=1,
            )
            with BuildSketch():
                Circle(2.75)
            extrude(until=Until.LAST, mode=Mode.SUBTRACT)
            with BuildSketch(Plane.XY.offset(3)):
                Circle(5)
            extrude(amount=100, mode=Mode.SUBTRACT)
            chamfer(main.edges(Select.LAST).group_by(Axis.Z)[-1], length=0.5)

        super().__init__(main.part, rotation=rotation, align=align, mode=mode)


class ArmAssembly(Compound):
    def __init__(
        self,
        *,
        frame_size_x: float = 200.0,
        arm_length: float = 225.0,
        arm_num_teeth: int = 80,
        label: str = "",
        color: Color | None = None,
        parent: Compound | None = None,
    ):
        children: list[Shape] = []

        rails = [
            VSlotLinearRail("20x20", arm_length, align=Align.CENTER).move(
                Location(
                    (-frame_size_x / 2 - 20, 0, 0),
                    (90, 0, 0),
                ),
            ),
            VSlotLinearRail("20x20", arm_length, align=Align.CENTER).move(
                Location(
                    (
                        +frame_size_x / 2 + 20 + 8.5,
                        0,
                        0,
                    ),
                    (90, 0, 0),
                ),
            ),
            VSlotLinearRail("20x20", frame_size_x, align=Align.CENTER).move(
                Location(
                    (
                        4.25,
                        arm_length / 2 - 10,
                        0,
                    ),
                    (0, 90, 0),
                ),
            ),
        ]
        for index, part in enumerate(rails):
            part.label = f"rail-{index}"
            part.color = None
        children.extend(rails)

        corner_a = CornerAssembly().move(
            Location(
                (
                    -frame_size_x / 2 - 20,
                    arm_length / 2 - 10,
                    0,
                ),
                (0, 0, -90),
            ),
        )
        corner_a.label = "corner-a"
        children.append(corner_a)
        corner_b = CornerAssembly(mirrored=True).move(
            Location(
                (
                    +frame_size_x / 2 + 28.5,
                    arm_length / 2 - 10,
                    0,
                ),
                (0, 0, 90),
            ),
        )
        corner_b.label = "corner-b"
        children.append(corner_b)

        end_cover = EndCover()
        end_covers = [
            copy(end_cover).move(
                Location(
                    (+frame_size_x / 2 + 28.5, -arm_length / 2, 0),
                    (90, 0, 0),
                ),
            ),
            copy(end_cover).move(
                Location((-frame_size_x / 2 - 20, -arm_length / 2, 0), (90, 0, 0)),
            ),
        ]
        for index, part in enumerate(end_cover):
            part.label = f"end-cap-{index}"
        children.extend(end_covers)

        screws = [
            copy(SCREW).move(
                Location(
                    (+frame_size_x / 2 + 28.5, -arm_length / 2 - 3, 0),
                    (-90, 0, 0),
                ),
            ),
            copy(SCREW).move(
                Location(
                    (-frame_size_x / 2 - 20, -arm_length / 2 - 3, 0),
                    (-90, 0, 0),
                ),
            ),
        ]
        for index, part in enumerate(screws):
            part.label = f"screw-{index}"
        children.extend(screws)

        apex_a = ApexAssembly(with_apex=False).move(
            Location(
                (-frame_size_x / 2 + 10, 0, 0),
                (0, 0, 180),
            ),
        )
        apex_a.label = "apex-a"
        children.append(apex_a)
        apex_b = ApexAssembly(with_apex=False, num_teeth=arm_num_teeth).move(
            Location(
                (+frame_size_x / 2 - 10, 0, 0),
            ),
        )
        apex_b.label = "apex-b"
        children.append(apex_b)
        self.pulley_radius = apex_b.pulley_radius

        super().__init__(
            label=label,
            color=color,
            parent=parent,
            children=children,
        )


class MotorPlate(BasePartObject):
    def __init__(
        self,
        num_rows: int = 1,
        thickness: float = 3,
        *,
        rotation: RotationLike = (0, 0, 0),
        align: Align | tuple[Align, Align, Align] | None = None,
        mode: Mode = Mode.ADD,
    ) -> None:
        with BuildPart() as main:
            with BuildSketch():
                with Locations((0, -10 * num_rows + 0.25)):
                    RectangleRounded(40, 20 * num_rows + 42, 5)
                Circle(12.5, mode=Mode.SUBTRACT)
                with PolarLocations(0, 4):
                    SlotArc(
                        Edge.make_line((13, 13), (15.5, 15.5)),
                        3.1,
                        mode=Mode.SUBTRACT,
                    )
                with Locations((0, -10 * num_rows - 22.55 + 1.3)):
                    with GridLocations(
                        x_spacing=10,
                        y_spacing=20,
                        x_count=3,
                        y_count=num_rows,
                    ):
                        Circle(3.05, mode=Mode.SUBTRACT)
            extrude(amount=thickness)

        super().__init__(main.part, rotation=rotation, align=align, mode=mode)


class MotorAssembly(Compound):
    def __init__(
        self,
        num_teeth: int = 20,
        rotation: float = 0,
        *,
        label: str = "",
        color: Color | None = None,
        parent: Compound | None = None,
    ):
        children: list[Shape] = []

        motor = StepperMotor("Nema17", motor_length=40)
        unset_color(motor)
        motor.label = "stepper-motor"
        children.append(motor)

        pulley = Pulley(
            num_teeth=num_teeth, axle_radius=2.5, rotation=(0, 0, rotation)
        ).translate((0, 0, 5))
        pulley.label = "pulley"
        children.append(pulley)
        self.pulley_radius = pulley.radius

        plate = MotorPlate(num_rows=1).rotate(Axis.Z, 90)
        plate.label = "motor-plate"
        children.append(plate)

        screws = [
            copy(SCREW).move(Location((31.25, -10, 3), (180, 0, 0))),
            copy(SCREW).move(Location((31.25, +10, 3), (180, 0, 0))),
        ]
        for index, part in enumerate(screws):
            part.label = f"screw-{index}"
        children.extend(screws)

        nuts = [
            copy(NUT).move(Location((31.25, -10, -5), (0, 0, 90))),
            copy(NUT).move(Location((31.25, +10, -5), (0, 0, 90))),
        ]
        for index, part in enumerate(nuts):
            part.label = f"nut-{index}"
        children.extend(nuts)

        super().__init__(
            label=label,
            color=color,
            parent=parent,
            children=children,
        )


class LimitSwitch(BasePartObject):
    def __init__(
        self,
        *,
        pressed: float = 0,
        rotation: RotationLike = (0, 0, 0),
        align: Align | tuple[Align, Align, Align] | None = None,
        mode: Mode = Mode.ADD,
    ) -> None:
        pressed = min(max(0, pressed), 1)

        with BuildPart() as lever:
            with BuildSketch():
                Rectangle(19, 4, align=(Align.MIN, Align.CENTER))
            extrude(amount=0.2)
            with BuildSketch(Plane.XZ):
                with Locations((17.25, 3.25)):
                    Circle(1.75)
                with Locations((17.25, 1.625)):
                    Rectangle(3.5, 3.25)
            extrude(amount=2.2, both=True)
            with BuildSketch(Plane.XZ), Locations((17.25, 3.25)):
                Circle(1)
            extrude(amount=2.5, both=True)
            with BuildSketch(Plane.YZ), Locations((0, 5.2)):
                Rectangle(4, 10)
            extrude(until=Until.LAST, mode=Mode.SUBTRACT)
            with BuildSketch(Plane.XZ), Locations((17.25, 3.25)):
                Circle(2.25)
            extrude(amount=2, both=True)

        with BuildPart() as main:
            with Locations((0, 0, 2.25)):
                Box(20, 6, 9.5)
            with BuildSketch(Plane.XZ), Locations((-5, 0), (+5, 0)):
                Circle(2.25)
                with Locations((0, -1.375)):
                    Rectangle(4.5, 2.75)
            extrude(amount=3.25, both=True)
            with BuildSketch(Plane.XZ), Locations((-5, 0), (+5, 0)):
                Circle(1.25)
            extrude(until=Until.LAST, both=True, mode=Mode.SUBTRACT)
            with BuildSketch(), Locations((8.5, 0), (1, 0), (-8, 0)):
                Rectangle(0.5, 3)
            extrude(amount=-6.5)
            with Locations(Location((-7, 0, 7), (0, -20 * (1 - pressed), 0))):
                insert(lever)

        super().__init__(main.part, rotation=rotation, align=align, mode=mode)


class LimitSwitchPlate(BasePartObject):
    def __init__(
        self,
        length: float = 30,
        *,
        rotation: RotationLike = (0, 0, 0),
        align: Align | tuple[Align, Align, Align] | None = None,
        mode: Mode = Mode.ADD,
    ) -> None:
        with BuildPart() as main:
            with BuildSketch(Plane.YZ):
                with Locations((-5, 0)):
                    Rectangle(length + 5, 20, align=Align.MIN)
                with Locations((length, 0)):
                    Rectangle(30, 30, rotation=30, align=Align.MIN, mode=Mode.SUBTRACT)
                with Locations(Location((length, 0), 30)):
                    height = 20 / cos(radians(30))
                    Rectangle(20, height, align=Align.MIN)
                    with Locations((10, height / 2 - 5.5), (10, height / 2 + 5.5)):
                        Circle(2.75, mode=Mode.SUBTRACT)
            extrude(amount=-3)
            with BuildSketch(Plane.YZ):
                Rectangle(10, 20, align=(Align.CENTER, Align.MIN))
            extrude(amount=-10)
            vertical = main.edges().filter_by(Axis.Z)
            vertical.remove(main.edges().group_by(Axis.X)[0].group_by(Axis.Y)[0][0])
            chamfer(vertical, length=2)
            with BuildSketch(Plane.YZ), Locations((0, 5), (0, 15)):
                Circle(1.5)
            extrude(until=Until.FIRST, mode=Mode.SUBTRACT)

        super().__init__(main.part, rotation=rotation, align=align, mode=mode)


class LimitSwitchAssembly(Compound):
    def __init__(
        self,
        *,
        arm_angle: float = 0.0,
        label: str = "",
        color: Color | None = None,
        parent: Compound | None = None,
    ):
        children: list[Shape] = []

        contact = 85.5
        switch = LimitSwitch(pressed=(arm_angle - contact) / (90 - contact)).move(
            Location((-13.25, 0, 10), (90, 0, -90)),
        )
        switch.label = "limit-switch"
        children.append(switch)

        switch_plate = LimitSwitchPlate(length=13)
        switch_plate.label = "limit-switch-plate"
        children.append(switch_plate)

        screws = [
            copy(SCREW).move(Location((-3, 18.65, 10.25), (0, 90, 0))),
            copy(SCREW).move(Location((-3, 13.15, 19.75), (0, 90, 0))),
        ]
        for index, part in enumerate(screws):
            part.label = f"screw-{index}"
        children.extend(screws)

        nuts = [
            copy(NUT).move(Location((5, 18.65, 10.25), (0, -90, -30))),
            copy(NUT).move(Location((5, 13.15, 19.75), (0, -90, -30))),
        ]
        for index, part in enumerate(nuts):
            part.label = f"nut-{index}"
        children.extend(nuts)

        super().__init__(
            label=label,
            color=color,
            parent=parent,
            children=children,
        )


class BumperAssembly(Compound):
    def __init__(
        self,
        *,
        label: str = "",
        color: Color | None = None,
        parent: Compound | None = None,
    ):
        children: list[Shape] = []

        end_stop = EndStop()
        end_stop.label = "end-stop"
        children.append(end_stop)

        screw = copy(SCREW).move(Location((0, 0, 4), (180, 0, 0)))
        screw.label = "screw"
        children.append(screw)

        nut = copy(NUT).move(Location((0, 0, -5), (0, 0, 90)))
        nut.label = "nut"
        children.append(nut)

        super().__init__(
            label=label,
            color=color,
            parent=parent,
            children=children,
        )


class FrameAssembly(Compound):
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
        frame_height = frame_size_y * sqrt(3) / 2
        if arm_length is None:
            arm_length = 1.5 * frame_size_y

        children: list[Shape] = []

        rails = [
            VSlotLinearRail("20x20", frame_size_x, align=Align.CENTER).move(
                Location((0, -frame_size_y / 2 - 10, 0), (0, 90, 0)),
            ),
            VSlotLinearRail("20x20", frame_size_x, align=Align.CENTER).move(
                Location((0, +frame_size_y / 2 + 10, 0), (0, 90, 0)),
            ),
            VSlotLinearRail("20x20", frame_size_y, align=Align.CENTER).move(
                Location((-frame_size_x / 2 + 10, 0, 0), (90, 0, 0)),
            ),
            VSlotLinearRail("20x20", frame_size_y, align=Align.CENTER).move(
                Location((+frame_size_x / 2 - 10, 0, 0), (90, 0, 0)),
            ),
            VSlotLinearRail("20x20", frame_size_y)
            .translate((0, 11.5, -0.5))
            .move(
                Location(
                    (+frame_size_x / 2 - 10, +frame_size_y / 2 - 1.5, 11.5),
                    (30, 0, 0),
                ),
            ),
            VSlotLinearRail("20x20", frame_size_y)
            .translate((0, 11.5, -0.5))
            .move(
                Location(
                    (-frame_size_x / 2 + 10, +frame_size_y / 2 - 1.5, 11.5),
                    (30, 0, 0),
                ),
            ),
            VSlotLinearRail("20x20", frame_size_y)
            .translate((0, -11.5, -0.5))
            .move(
                Location(
                    (+frame_size_x / 2 - 10, -frame_size_y / 2 + 1.5, 11.5),
                    (-30, 0, 0),
                ),
            ),
            VSlotLinearRail("20x20", frame_size_y)
            .translate((0, -11.5, -0.5))
            .move(
                Location(
                    (-frame_size_x / 2 + 10, -frame_size_y / 2 + 1.5, 11.5),
                    (-30, 0, 0),
                ),
            ),
        ]
        for index, part in enumerate(rails):
            part.label = f"rail-{index}"
            part.color = None
        children.extend(rails)

        foot_a = FootAssembly()
        foot_b = FootAssembly(mirrored=True)
        feet = [
            copy(foot_b).move(
                Location(
                    (-frame_size_x / 2 + 10, -frame_size_y / 2 - 10, 0),
                    (0, 0, -90),
                ),
            ),
            copy(foot_a).move(
                Location(
                    (+frame_size_x / 2 - 10, -frame_size_y / 2 - 10, 0),
                    (0, 0, 90),
                ),
            ),
            copy(foot_a).move(
                Location(
                    (-frame_size_x / 2 + 10, +frame_size_y / 2 + 10, 0),
                    (0, 0, -90),
                ),
            ),
            copy(foot_b).move(
                Location(
                    (+frame_size_x / 2 - 10, +frame_size_y / 2 + 10, 0),
                    (0, 0, 90),
                ),
            ),
        ]
        for index, part in enumerate(feet):
            part.label = f"foot-{index}"
        children.extend(feet)

        apex_a = ApexAssembly(with_arm=False).move(
            Location(
                (-frame_size_x / 2 + 10, 0, frame_height + 25.5),
                (0, 0, 180),
            ),
        )
        apex_a.label = "apex-a"
        children.append(apex_a)
        apex_b = ApexAssembly(with_arm=False).move(
            Location(
                (+frame_size_x / 2 - 10, 0, frame_height + 25.5),
            ),
        )
        apex_b.label = "apex-b"
        children.append(apex_b)

        arm = ArmAssembly(
            frame_size_x=frame_size_x,
            arm_length=arm_length,
            arm_num_teeth=arm_num_teeth,
        ).move(
            Location((0, 0, frame_height + 25.5), (arm_angle, 0, 0)),
        )
        arm.label = "arm"
        children.append(arm)

        motor_rotation = arm_angle * arm_num_teeth / motor_num_teeth
        motor = MotorAssembly(motor_num_teeth, motor_rotation).move(
            Location((frame_size_x / 2, 0, 31.25), (0, 90, 0)),
        )
        motor.label = "motor"
        children.append(motor)

        belt_offset = arm_angle * arm.pulley_radius * pi / 180
        belt = (
            Belt(
                pulley_a_location=(-31.25, 0),
                pulley_a_radius=motor.pulley_radius,
                pulley_b_location=(-frame_height - 25.5, 0),
                pulley_b_radius=arm.pulley_radius,
                offset=belt_offset,
            )
            .rotate(Axis.Y, 90)
            .translate((frame_size_x / 2 + 8.5, 0, 0))
        )
        belt.label = "belt"
        children.append(belt)

        switch = LimitSwitchAssembly(arm_angle=arm_angle).move(
            Location((-frame_size_x / 2, 22.5, frame_height - 49.5)),
        )
        switch.label = "limit-switch"
        children.append(switch)

        bumper = BumperAssembly()
        bumpers = [
            copy(bumper)
            .translate((0, -0.25 * frame_size_y - 20, 21.5))
            .move(
                Location(
                    (-frame_size_x / 2 + 10, +frame_size_y / 2 - 1.5, 11.5),
                    (-60, 0, 0),
                ),
            ),
            copy(bumper)
            .translate((0, -0.25 * frame_size_y - 20, 21.5))
            .move(
                Location(
                    (+frame_size_x / 2 - 10, +frame_size_y / 2 - 1.5, 11.5),
                    (-60, 0, 0),
                ),
            ),
        ]
        for index, part in enumerate(bumpers):
            part.label = f"bumper-{index}"
        children.extend(bumpers)

        super().__init__(
            label=label,
            color=color,
            parent=parent,
            children=children,
        )

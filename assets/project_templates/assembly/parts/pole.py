from build123d import *
from ..parameters import *


class Pole(BasePartObject):
    def __init__(
        self,
        length: float,
        name="pole",
        rotation=(0, 0, 0),
        align: tuple[Align, Align, Align] = (Align.CENTER, Align.CENTER, Align.MIN),
        mode: Mode = Mode.ADD,
    ):
        self.name = name
        alignment = (Align.CENTER, Align.CENTER, Align.MIN)
        part = Box(stock_side, stock_side, length - stock_side, align=alignment)
        with BuildPart():
            with Locations((0, 0, length - stock_side)):
                with GridLocations(stock_side * 2 / 3, stock_side * 2 / 3, 2, 2):
                    part += Box(
                        stock_side / 3, stock_side / 3, stock_side, align=alignment
                    )
        super().__init__(part=part, rotation=rotation, align=align, mode=mode)
        RigidJoint(
            "beam-pole",
            self,
            Location(
                self.faces().filter_by(Plane.XY).sort_by(Axis.Z)[-5].center(), (0, 0, 0)
            ),
        )


if __name__ == "__main__":
    from VIEWER_LIBRARY import show

    pole = Pole(100)
    show(pole, render_joints=True)

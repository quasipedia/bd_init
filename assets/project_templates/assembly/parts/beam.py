from build123d import *
from ..parameters import *


class Beam(BasePartObject):
    def __init__(
        self,
        length: float,
        flip_joint: bool = False,  # A "normal" and a "flipped" joint match
        name="beam",
        align: tuple[Align, Align, Align] = (Align.CENTER, Align.CENTER, Align.MIN),
        mode: Mode = Mode.ADD,
    ):
        self.name = name
        alignment = (Align.CENTER, Align.CENTER, Align.MIN)
        # Active part of the joint
        hook = Box(stock_side, stock_side / 3, stock_side, align=alignment)
        hook -= Pos(0, 0, stock_side / 2) * Box(
            stock_side / 3, stock_side / 3, stock_side / 2, align=alignment
        )
        # Structural part
        beam = Pos(-stock_side / 2, 0, 0) * Box(
            length - stock_side,
            stock_side,
            stock_side,
            align=(Align.MAX, Align.CENTER, Align.MIN),
        )
        # Putting it together
        part = beam + hook
        super().__init__(part=part, align=align, mode=mode)
        face = self.faces().sort_by(SortBy.AREA)[:3].sort_by(Axis.Z)[0]
        RigidJoint(
            "beam-pole",
            self,
            Location(face.center() + (0, 0, -stock_side / 2), (0, 0, 0)),
        )
        RigidJoint(
            "beam-beam",
            self,
            Location(face.center(), (180, 0, 90) if flip_joint else (0, 0, 0)),
        )


if __name__ == "__main__":
    from VIEWER_LIBRARY import show

    beam = Beam(100)
    face = beam.faces().sort_by(SortBy.AREA)[:3].sort_by(Axis.Z)[0]
    show(face, beam)

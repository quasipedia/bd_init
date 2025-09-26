from build123d import *
from CAD_LIBRARY import show

L, w, t, b, h, n = 60.0, 18.0, 9.0, 0.9, 90.0, 6.0

with BuildPart() as bottle:
    with BuildSketch(Plane.XY.offset(-b)):
        with BuildLine() as bottle_contour:
            l1 = Line((0, 0), (0, w / 2))
            l2 = ThreePointArc(l1 @ 1, (L / 2.0, w / 2.0 + t), (L, w / 2.0))
            l3 = Line(l2 @ 1, ((l2 @ 1).X, 0, 0))
            mirror(bottle_contour.line)
        make_face()
    extrude(amount=h + b)
    fillet(bottle.edges(), radius=w / 6)
    with BuildSketch(bottle.faces().sort_by(Axis.Z)[-1]):
        Circle(t)
    extrude(amount=n)
    necktopf = bottle.faces().sort_by(Axis.Z)[-1]
    offset(bottle.solids()[0], amount=-b, openings=necktopf)

show(bottle)
export_step(bottle.part, "artifacts/bottle.step")

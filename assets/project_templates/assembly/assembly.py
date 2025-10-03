from pathlib import Path

from build123d import *
from VIEWER_LIBRARY import *

from .parameters import *
from .parts import Beam, Pole


def _get_artifact_directory():
    """Get the target directory where to output the artifacts."""
    # This is a hack. I would have preferred to implement it with the .env
    # file in `uv`, but at present that feature requires passing an extra
    # parameter to the command line, which I don't want to do as I prefer to
    # keep things simple for the end user.
    # Also see: https://github.com/astral-sh/uv/issues/8862
    target_dir = Path(__file__)
    while True:
        if Path.is_dir(target_dir / "artifacts"):
            return target_dir / "artifacts"
        if target_dir == target_dir.parent:  # We reached root
            return Path.cwd()
        target_dir = target_dir.parent


def export(*parts):
    """Create the files for using the geometry in other software"""
    artifact_directory = _get_artifact_directory()
    for part in parts:
        export_step(part, "{}/{}.step".format(artifact_directory, part.name))


def assemble():
    x_beam = Beam(x_beam_length)
    y_beam = Beam(y_beam_length, flip_joint=True)
    pole = Pole(pole_length)
    x_beam.color = "orangered"
    y_beam.color = "darkolivegreen"
    pole.color = "steelblue"
    export(x_beam, y_beam, pole)
    x_beam.joints["beam-beam"].connect_to((y_beam.joints["beam-beam"]))
    x_beam.joints["beam-pole"].connect_to((pole.joints["beam-pole"]))
    show(x_beam, y_beam, pole)


if __name__ == "__main__":
    assemble()

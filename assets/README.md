# TEMPLATE_PROJECT_NAME

`TEMPLATE_PROJECT_NAME` is a project using [`build123d`](https://github.com/gumyr/build123d),
which in turn is a python-based boundary representation (BREP) modeling framework, built on
the Open Cascade geometric kernel).

That is to say: **by running the code you will generate geometries that you may
later export and use for fabrication**, for example with a 3D printer. 

Think a traditional CAD packages like FreeCAD or SolidWorks... but rather than using
a GUI, you write code instead.


## Requirements

This projects use [uv](https://docs.astral.sh/uv/) for managing the virtual
environment, the dependencies, and the scripts.  All you need to use this
project is to make sure you have `uv` installed in your system.


## Generating the STEP files

To create the `.step` files to be used by a 3D slicer or other software run

```console
>>> uv run TEMPLATE_PACKAGE_NAME
```

The STEP files will be under the `artifacts/` directory in the root of the project 


## Displaying the geometry in a viewer

${TEMPLATE_VIEWER_INSTRUCTIONS}

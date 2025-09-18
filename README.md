# Initialise a Build123d project

This is a simple script to automate the initialisation of [`Build123d`](https://github.com/gumyr/build123d) projects.

## Scope
The script (unchecked features are still not operational):
- [x] prepares an isolated enivironment for the project,
- [x] installs all dependencies (including `--dev` ones)
- [x] takes care of the directory structure
- [ ] creates a relevant `.gitignore` file
- [ ] prepares and fill-in the `pyproject.py` and `pyproject.toml`
- [ ] configure the varius dev tools (e.g.: `ruff`)
- [ ] creates a minimal `example.py` file

Explicitly out-of-scope:
- IDE or text editor configuration.

## Dependencies
The script core functionality is provided by [`uv`](https://github.com/astral-sh/uv), so you _must_ have `uv` installed on your system.  Other programs that are expected to be installed on the system are `bash` and `readlink`, but those are fairly typical in any modern GNU/Linux distribution.

## Usage
The format for running the script is:

```bash
./init-b123-project.sh <project-name> <project-type> <preferred-viewer>
```

where:
- `project-name` will be the name of the project AND of the directory (created where the script is currently running) containing all the code _and_ the virtual environment,
- `project-type` is one of `bare`, `package` or `lib` (see [uv documentation](https://docs.astral.sh/uv/concepts/projects/init/) for details on the differences between the three of them)
- `preferred-viewer` is one of [`ocp`](https://github.com/bernhard-42/vscode-ocp-cad-viewer) or [`yacv`](https://github.com/yeicor-3d/yet-another-cad-viewer).

Examples:
```
./init-b123-project.sh simple_wedge bare yacv
./init-b123-project.sh marble_run package ocp
./init-b123-project.sh lego_parts lib yacv
```

Tip: you probably want to symlink the script in the root of our CAD code projects directory (or anyway make it available on PATH).

## Lincense
© 2025. This work is openly licensed via [CC0](https://creativecommons.org/publicdomain/zero/1.0/)

# Initialise a Build123d project

This is a simple script to automate the initialisation of [`Build123d`](https://github.com/gumyr/build123d) projects.

## Scope
The script (unchecked features are still not operational):
- [x] prepares an isolated enivironment for the project,
- [x] installs all dependencies (including `--dev` ones)
- [x] takes care of the directory structure
- [x] creates a relevant `.gitignore` file
- [x] configure the varius dev tools (e.g.: `ruff`)
- [ ] creates a minimal `example.py` file

Explicitly out-of-scope:
- IDE or text editor configuration.

## Dependencies
The script core functionality is provided by [`uv`](https://github.com/astral-sh/uv), so you _must_ have `uv` installed on your system. Other programs that are expected to be installed on the system are `bash`, `sed`, and `readlink`, but these are typically installed by default in any modern GNU/Linux distribution.

## Usage
The format for running the script is:

```bash
./init-b123-project.sh <project-name> <project-type> <preferred-viewer>
```

where:
- `project-name` will be the name of the project AND of the directory (created where the script is currently running) containing all the code _and_ the virtual environment,
- `project-type` is one of `bare`, `app`, `package` or `lib` (see [uv documentation](https://docs.astral.sh/uv/concepts/projects/init/) for details on the differences between them)
- `preferred-viewer` is one of [`ocp`](https://github.com/bernhard-42/vscode-ocp-cad-viewer) or [`yacv`](https://github.com/yeicor-3d/yet-another-cad-viewer).

Examples:
```
./init-b123-project.sh simple_wedge bare yacv
./init-b123-project.sh marble_run package ocp
./init-b123-project.sh lego_parts lib yacv
```

## TIPS
- You probably want to symlink the script in the root of our CAD code projects directory (or anyway make it available on PATH).
- This script saves all the output of the commands it runs in the `creation_log.txt` file in the root of the newly created project. The file is meant for debugging any problem one may encounter with the script; after the project creation it can be safely deleted (all the info needed for replicability of the project are already in the `pyproject.toml` and `uv.lock` files). As an additional precaution, the file is added by default to `.gitignore`, so it won't get committed by mistake (some personal infomrations like the name of the user may be visible there).

## Lincense
© 2025. This work is openly licensed via [CC0](https://creativecommons.org/publicdomain/zero/1.0/)

# BD Init - Get designing in seconds!
This is a script to automate the initialisation of [`Build123d`](https://github.com/gumyr/build123d) projects, a CAD code package.
With it, you will be able to get going with your CAD design in about 20 seconds:

https://github.com/user-attachments/assets/dd4bc28a-c479-4495-94d4-2e806d853122


## Dependencies
**The script core functionality is provided by [`uv`](https://github.com/astral-sh/uv), so you _must_ have `uv` installed on your system.**
The other dependencies of the script are typically installed by default in any modern GNU/Linux distribution, some of them are:
- `bash`
- `curl`
- `cut`
- `jq`
- `readlink`
- `sed`


## Installation
The recommended way to install the script is to clone the repository where you keep your code and **either**:
```sh
~ ❯❯❯ cd code
~/code ❯❯❯ git clone git@github.com:quasipedia/bd_init.git
```
### Option one
If all your CAD projects share the same folder, create a symlink to `bd_init.sh` in that directory.
```sh
~/cad_projects ❯❯❯ ln -s ~/code/bd_init/bd_init.sh
```
### Option two
If you need or prefer to be able to invoke the script from anywhere in your system, append the cloned directory to your system `$PATH` by adding to your shell initialisation script (e.g.: `~/.bashrc` or `~/.zshrc`) the following line:
```sh
export PATH="~/code/bd_init:$PATH"
```


## Usage
The format for running the script is:

```sh
./bd_init.sh <project-name> <project-type> <preferred-viewer>
```

where:
- `project-name` will be the name of the project AND of the directory (created where the script is currently running) containing all the code _and_ the virtual environment,
- `project-type` is one of `bare`, `app`, `package` or `lib` (see [uv documentation](https://docs.astral.sh/uv/concepts/projects/init/) for details on the differences between them)
- `preferred-viewer` is one of [`ocp`](https://github.com/bernhard-42/vscode-ocp-cad-viewer) or [`yacv`](https://github.com/yeicor-3d/yet-another-cad-viewer).

Examples:
```
bd_init test bare yacv
bd_init simple-wedge app yacv
bd_init marble-run package ocp
bd_init lego-parts lib yacv
```

## Tips
- This script saves all the output of the commands it runs in the `creation_log.txt` file in the root of the newly created project. The file is meant for debugging any problem one may encounter with the script; after the project creation it can be safely deleted (all the info needed for replicability of the project are already in the `pyproject.toml` and `uv.lock` files). As an additional precaution, the file is added by default to `.gitignore`, so it won't get committed by mistake.
- `bd_init` will also create a `nuke.sh` script in the project folder, which automates the process of removing the entire project, including configuration options that IPython keeps outside of the project folder (you will be prompted for confirmation beforheands).


## Features
The script (unchecked features are still _not_ operational) does:
- [x] notify if newer versions of `bd_script` are available
- [x] prepare an isolated `.venv` for the project,
- [x] install all dependencies (including `--dev` ones)
- [x] configure the varius dev tools (e.g.: `ruff`)
- [x] create a relevant `.gitignore` file
- [x] install `nuke.sh`, a script to completely purge the project from the system
- [x] creates a custom `README.md` file (generic but informative)
- [ ] creates a minimal working example tailored to your chosen type of project and CAD viewer

Explicitly out-of-scope:
- IDE or text editor configuration.


## Contributing
You are more than welcome to open an issue or a pull-requests if you find a bug, want to add a feature, improve on the existing functionality or if you simply have some feedback that you would like to share.


## Lincense
© 2025. This work is openly licensed via [CC0](https://creativecommons.org/publicdomain/zero/1.0/)

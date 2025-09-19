#/urs/bin/env bash

# Scrip to initialise a build123d project
# Prerequisite: `uv` installed on the system
# Usage: ./init-b123-project.sh <project-name> <project-type> <cad-viewer>
# (it will initialise the project in a directory called <project-name>)
# Exemples:
#   ./init-b123-project.sh lego_parts lib yacv
#   ./init-b123-project.sh marble_run package ocp
#   ./init-b123-project.sh mobile_mount app yacv
#   ./init-b123-project.sh cube bare yacv

# COLOURS
RED='\033[1;31m'
GREEN='\033[1;32m'
NC='\033[0m' # Normal Color

# REGEX PATTERNS
pattern_project_type="(\s|^)$2(\s|\$)"
pattern_viewer_selection="(\s|^)$3(\s|\$)"

# FIND OUT WHERE THE ORIGINAL FILE OF THE SCRIPT IS STORED
# This is needed in order to retrieve the template files to be installed in
# the project.  Finding this relaibly in bash is rather challenging, as the
# script my just be in the directory it is ran from, may be on the $PATH, or
# may be symlinked.
DIR="$(dirname "$(readlink -f "$0")")"  # Try to resolve as a symlink...
if [ $? == 1 ]; then  # ...if it fails...
  DIR="$(cd "$(dirname "$0")" && pwd)"  # ...resolve like this instead
fi

# HELPER FUNCTIONS
echo_error() {
  echo -e "${RED}${1}${NC}"
}
echo_info() {
  echo -e "${GREEN}${1}${NC}"
}

if [ -z "$1" ]; then
  echo_error "Please provide the name of the project"
  exit 1
elif [ -z "$2" ] || [[ ! "bare app package lib" =~ $pattern_project_type ]]; then
  echo_error "Please provide the type of project (bare|app|package|lib)"
  exit 1
elif [ -z "$3" ] || [[ ! "ocp yacv" =~ $pattern_viewer_selection ]]; then
  echo_error "Please indicate what type of viewer you would like to use (ocp|yacv)"
  exit 1
fi

# Clash prevention (with existing project)
if [ -d $1 ]; then
  echo_error "The project directory already exists. Aborting."
  exit 1
fi

# Create the directory for the project
echo_info "CREATING PROJECT '$1'..."
uv init --$2 $1 &> creation_log_$1.txt
mv creation_log_$1.txt $1/creation_log.txt

set -e
pushd $1 > /dev/null

# Install dependencies
echo_info "Installing essential dependencies..."
# build123d
uv add 'git+https://github.com/gumyr/build123d.git' >> creation_log.txt 2>&1
# viewer of choice
if [[ $3 == "ocp" ]]; then
  uv add ocp_vscode >> creation_log.txt 2>&1
else
  uv add yacv-server >> creation_log.txt 2>&1
fi
  
# Iron python (considered a --dev dependency as if you are simply "using" the
# code by running it once to generate a part, there is no advantage in using
# Ipython)
echo_info "Installing Iron Python kernel..."
uv add --dev ipykernel >> creation_log.txt 2>&1
uv run ipython kernel install --user --env VIRTUAL_ENV "$(pwd)/.venv" --name="$1" >> creation_log.txt 2>&1

# Install other --dev tools (my personal preference)
echo_info "Installing --dev dependencies"
uv add --dev ty >> creation_log.txt 2>&1
uv add --dev ruff >> creation_log.txt 2>&1
uv add --dev python-language-server >> creation_log.txt 2>&1
uv add --dev basedpyright >> creation_log.txt 2>&1
# Alternative and additional --dev tools (choose your poison!)
# uv add --dev jedi-language-server
# uv add --dev cadquery-ocp-stubs

# Install configuration files
echo_info "Installing configuration files"
cp "$DIR/assets/git-ignore" .gitignore
cp "$DIR/assets/ruff.toml" .
cp "$DIR/assets/pyrightconfig.json" .
python_version=$(uv run python --version | cut -d ' ' -f 2)
sed -i s/TEMPLATE_PYTHON_VERSION/$python_version/g pyrightconfig.json

# Installing the relevant example for the chosed viewer
echo_info "Installing example file using $3"
cp "$DIR/assets/$3-example.py" example.py

popd > /dev/null
set +e


#/urs/bin/env bash

# Scrip to initialise a build123d project
# Prerequisite: `uv` installed on the system
# Usage: ./init-b123-project.sh <project-name> <project-type> <cad-viewer>
# (it will initialise the project in a directory called <project-name>)
# Exemples:
#   ./init-b123-project.sh lego_parts lib yacv
#   ./init-b123-project.sh marble_run package ocp
#   ./init-b123-project.sh simple_wedge bare yacv


# REGEX PATTERNS
pattern_project_type="(\s|^)$2(\s|\$)"
pattern_viewer_selection="(\s|^)$3(\s|\$)"

if [ -z "$1" ]; then
  echo "Please provide the name of the project"
  exit 1
elif [ -z "$2" ] || [[ ! "bare package lib" =~ $pattern_project_type ]]; then
  echo "Please provide the type of project (bare|package|lib)"
  exit 1
elif [ -z "$3" ] || [[ ! "ocp yacv" =~ $pattern_viewer_selection ]]; then
  echo "Please indicate what type of viewer you would like to use (ocp|yacv)"
  exit 1
else
  echo "Creating project '$1'"
fi

# Clash (with existing project) prevention
if [ -d $1 ]; then
  echo "The project directory already exists. Aborting."
  exit 1
fi

# Create the directory for the project
uv init --$2 $1

# Install dependencies
set -e
pushd $1
# build123d
uv add git+https://github.com/gumyr/build123d.git
# viewer of choice
if [[ $3 == "ocp" ]]; then
  uv add ocp_vscode
else
  uv add yacv-server
# Iron python
uv add --dev ipykernel
uv run ipython kernel install --user --env VIRTUAL_ENV $(pwd)/.venv --name=<name> --display-name=<display-name>


popd
set +e

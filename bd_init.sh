#!/usr/bin/env bash

# Scrip to initialise a build123d project
# Prerequisite: `uv` installed on the system
# Usage: ./init-b123-project.sh <project-name> <project-type> <cad-viewer>
# (it will initialise the project in a directory called <project-name>)

set -e

# #############################################################################
#    PREP WORK                                                                #
# #############################################################################

# USE NAMED VARIABLES
project_name=$1
project_type=$2
viewer=$3

# TRANSLATE CAD NAMES TO UV INIT OPTIONS
declare -A UV_MAPPING
UV_MAPPING["empty"]="bare"
UV_MAPPING["part"]="app"
UV_MAPPING["assembly"]="package"
UV_MAPPING["library"]="lib"

# TRANSLATE VIEWER NAMES TO PYTHON MODULES
declare -A MOD_MAPPING
MOD_MAPPING["ocp"]="ocp_vscode"
MOD_MAPPING["yacv"]="yacv_server"

# COLOURS
RED='\033[1;31m'
YELLOW='\033[1;93m'
GREEN='\033[1;32m'
BOLD='\033[1m'
NC='\033[0m' # Normal Color

# FIND OUT WHERE THE ORIGINAL FILE OF THE SCRIPT IS STORED
# This is needed in order to retrieve the template files to be installed in
# the project.  Finding this relaibly in bash is rather challenging, as the
# script my just be in the directory it is ran from, may be on the $PATH, or
# may be symlinked.
DIR="$(dirname "$(readlink -f "$0")")"  # Try to resolve as a symlink...
if [ $? == 1 ]; then  # ...if it fails...
  DIR="$(cd "$(dirname "$0")" && pwd)"  # ...resolve like this instead
fi

# #############################################################################
#    HELPER FUNCTIONS                                                         #
# #############################################################################

echo_error() {
  echo -e "${RED}${1}${NC}"
}

echo_warn() {
  echo -e "${YELLOW}${1}${NC}"
}

echo_info() {
  echo -e "${GREEN}${1}${NC}"
}

echo_bold() {
  echo -e "${BOLD}${1}${NC}"
}

is_valid_option() {
  pattern="(\s|^)$2(\s|$)"
  if [[ "$1" =~ $pattern ]]; then
    return 0
  else
    return 1
  fi
}

offer_to_abort() {
  read -r stop_now
  if ! [ "$stop_now" == "n" ]; then
    echo "Aborting."
    exit 0
  fi
}

# #############################################################################
#    VALIDATION                                                               #
# #############################################################################

# Check that you are running the latest and greatest version of the project
bd_init_latest=$(curl -s "https://api.github.com/repos/quasipedia/bd_init/tags" | jq -r '.[0].name')
bd_init_current=$(git -C "$DIR" describe --tags --abbrev=0)
if ! [ "$bd_init_latest" == "$bd_init_current" ]; then
  echo_warn "New version of \`bd_init\` available!"
  echo "You are running v.$(echo_bold v."$bd_init_current") of \`bd_init\`, if you have installed it by cloning"
  echo "the repository, you can upgrade to $(echo_bold v."$bd_init_latest") by issuing:"
  echo ""
  echo "    cd $DIR && git pull"
  echo ""
  echo_warn "Would you like to abort and upgrade now? (Y|n)"
  offer_to_abort
fi

# Validate parameters
if [ -z "$project_name" ]; then
  echo_error "Please provide the name of the project"
  exit 1
elif ! [[ $project_name =~ ^[a-z|0-9|\-]*$ ]]; then
  echo_warn "Potentially problematic project name!"
  echo "Some tooling in the python ecosystem treat letter casing and some"
  echo "some other characters like underscores and spaces in special ways."
  echo "For example sometimes spaces and underscores get silently converted"
  echo "to hyphens. This is not a problem if you only work locally, but can"
  echo "become a problem when sharing a codebase with others."
  echo ""
  echo_warn "Would you like to abort and change the project name to something"
  echo_warn "containing only lowercase letters, hyphens and digits? (Y|n)"
  offer_to_abort 
elif [ -z "$project_type" ] || ! is_valid_option "empty part assembly library" "$project_type"; then
  echo_error "Please provide the type of project (empty|part|assembly|library)"
  echo_error "See documentation for details."
  exit 1
elif [ -z "$viewer" ] || ! is_valid_option "ocp yacv" "$viewer"; then
  echo_error "Please indicate what type of viewer you would like to use (ocp|yacv)"
  exit 1
fi

# Clash prevention (with existing project)
if [ -d "$project_name" ]; then
  echo_error "The project directory already exists. Aborting."
  exit 1
fi

# #############################################################################
#    BUSINESS LOGIC                                                           #
# #############################################################################

# Create the directory for the project
echo_info "CREATING PROJECT \`$project_name\`..."
uv init --"${UV_MAPPING[$project_type]}" "$project_name" &> creation_log_"$project_name".txt
mv creation_log_"$project_name".txt "$project_name"/creation_log.txt

pushd "$project_name" > /dev/null

# Install dependencies
echo_info "Installing essential dependencies..."
# build123d
uv add 'git+https://github.com/gumyr/build123d.git' >> creation_log.txt 2>&1
# viewer of choice
if [[ $viewer == "ocp" ]]; then
  uv add ocp_vscode >> creation_log.txt 2>&1
else
  uv add yacv-server >> creation_log.txt 2>&1
fi
  
# IPython (considered a --dev dependency as if you are simply "using" the
# code by running it once to generate a part, there is no advantage in using
# Ipython)
echo_info "Installing IPython kernel..."
uv add --dev ipykernel >> creation_log.txt 2>&1
uv run ipython kernel install --user --env VIRTUAL_ENV "$(pwd)/.venv" --name="$project_name" >> creation_log.txt 2>&1

# Install other --dev tools (my personal preference)
echo_info "Installing --dev dependencies..."
{
  uv add --dev ty
  uv add --dev ruff
  uv add --dev ruff-lsp
  uv add --dev python-language-server
  uv add --dev basedpyright
} >> creation_log.txt 2>&1
# Alternative and additional --dev tools (choose your poison!)
# uv add --dev jedi-language-server
# uv add --dev cadquery-ocp-stubs

# Install configuration files
echo_info "Installing configuration files..."
cp "$DIR/assets/git-ignore" .gitignore
cp "$DIR/assets/ruff.toml" .
cp "$DIR/assets/pyrightconfig.json" .
python_version=$(uv run python --version | cut -d ' ' -f 2)
sed -i s/TEMPLATE_PYTHON_VERSION/"$python_version"/g pyrightconfig.json

# Install custom README file
echo_info "Generating custom README file..."
cp "$DIR/assets/README.md" .
sed -i s/TEMPLATE_PROJECT_NAME/"$project_name"/g README.md

# Installing the script to remove the project
uv add --dev toml-cli >> creation_log.txt 2>&1
cp "$DIR/assets/nuke.sh" .

# Install project template
if ! [ "$project_type" == empty ]; then
  # Creating the directories
  echo_info "Installing project template..."
  mkdir artifacts
  cp -r "$DIR"/assets/project_templates/"$project_type"/* .
  find . -path '*/.*' -prune -o -name "*.py" -exec sed -i s/CAD_LIBRARY/"${MOD_MAPPING[$viewer]}"/g {} \;
fi

echo_info "...ALL DONE!"
popd > /dev/null
set +e

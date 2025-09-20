#/urs/bin/env bash

# This script completely removes the project from the system, INCLUDING THE
# CODE the user has created.  Most notably, it automatise the removal of the
# IPython kernel.

set -e

# COLOURS
YELLOW='\033[1;93m'
GREEN='\033[1;32m'
NC='\033[0m' # Normal Color

# HELPER FUNCTIONS
echo_warn() {
  echo -e "${YELLOW}${1}${NC}"
}
echo_info() {
  echo -e "${GREEN}${1}${NC}"
}

# FIND OUT WHAT PROJECTS WE ARE IN
project_name=$(uv run toml get --toml-path pyproject.toml project.name)

echo_warn "You are about to COMPLETELY REMOVE PROJECT \`$project_name\` from your system.\nThis includes among others:"
echo_warn "• All of the code you wrote"
echo_warn "• The virtual environment and all installed dependencies"
echo_warn "• The IPython kernel installed at system level"
echo_warn ""
echo_warn "If you are ABSOLUTELY SURE this is what you want to do, type the name of the project (\`$project_name\`) here below"

read last_famous_words

if ! [ $last_famous_words == $project_name ]; then
  echo_info "The project has been left intact"
  exit 0
fi

# Remove the project
echo "Removing the kernel..."
yes | uv run jupyter kernelspec remove $project_name > /dev/null
echo "Removing code and virtual environment..."
target_directory=$(pwd)
rm -rf "$target_directory" # ATTN! Mind the `"` or spaces in dir name may break havoc!!
echo_info "The project has been successfuly removed."
echo "Upon exiting this directory, the directory itself will disappear from the system."

set +e

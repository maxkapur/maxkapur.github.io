#!/usr/bin/env bash

# Global options
shopt -s globstar


# Print a header in blue
function header () {
    printf '\033[96m%s\033[0m\n' "$1" 1>&2
}


# Print an error in red
function error () {
    printf '\033[91mE: %s\033[0m\n' "$1" 1>&2
}


# Verify, by inspecting _scripts/.directory_id.txt, that the current working
# directory is the repository root.
function verify_working_directory () {
    if [ ! -f ./_scripts/.directory_id ]
    then
        error "Missing directory identifier"
        return 1
    elif [ "$(cat ./_scripts/.directory_id)" != "6b765dd0-0781-4ad5-8abd-8b8d85494a1d" ]
    then
        error "Incorrect directory identifier"
        return 1
    fi
}

# All scripts should be run from the root
verify_working_directory || exit $?

# Source additional common functions here
source ./_scripts/activate_conda_environment.sh
source ./_scripts/check_bundler_updated.sh
source ./_scripts/check_conda_updated.sh
source ./_scripts/check_trailing_whitespace.sh

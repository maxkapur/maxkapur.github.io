#!/usr/bin/env bash

set -ex
shopt -s globstar

# These checks have mutating counterparts in format.sh
mdformat ./**/README.md --number --wrap 80 --check
nixfmt flake.nix --check
prettier . --check
ruff format --check
ruff check
shellcheck ./*.sh

# These checks don't
TEMP_DIR="$(mktemp --directory)"
hugo build --destination "$TEMP_DIR"
htmltest --conf .htmltest.yml --skip-external "$TEMP_DIR"

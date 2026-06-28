#!/usr/bin/env bash

set -ex

# These checks have mutating counterparts in format.sh
nixfmt flake.nix --check
prettier . --check --verbose
ruff format --check
ruff check
shellcheck ./*.sh

# These checks don't
TEMP_DIR="$(mktemp --directory)"
hugo build --destination "$TEMP_DIR"
htmltest --conf .htmltest.yml --skip-external "$TEMP_DIR"

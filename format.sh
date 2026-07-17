#!/usr/bin/env bash

set -e
shopt -s globstar

mdformat ./**/README.md --number --wrap 80
nixfmt flake.nix
prettier . --write
ruff format
ruff check --fix
shellcheck ./*.sh

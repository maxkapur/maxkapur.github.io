#!/usr/bin/env bash

set -e

nixfmt flake.nix
prettier . --write --verbose
ruff format
ruff check --fix
shellcheck ./*.sh

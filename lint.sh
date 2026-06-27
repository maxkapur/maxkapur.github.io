#!/usr/bin/env bash

set -ex

nixfmt flake.nix --check
prettier . --check --verbose
ruff format --check
ruff check
shellcheck ./*.sh

#!/usr/bin/env bash

# Configure a workstation to build/develop the static site. Tested on Ubuntu
# 22.04.

set -x
set -e

TMP_CONDA_PREFIX=$(realpath "./.conda")
if [ -d "$TMP_CONDA_PREFIX" ]; then rm -ri "$TMP_CONDA_PREFIX"; fi

# CI=True to prevent weird progress bar
# https://github.com/mamba-org/mamba/issues/1478
CI="True" mamba create \
    --yes \
    --prefix "$TMP_CONDA_PREFIX" \
    --no-default-packages \
    --override-channels \
    --channel conda-forge \
    "compilers=1.8.*" \
    "make=4.*" \
    "ruby=3.2.*" \
    "shellcheck=0.10.*"

# Fixes issue where bundle looks for ruby3.2 instead of ruby
ln -s "$TMP_CONDA_PREFIX/bin/ruby" "$TMP_CONDA_PREFIX/bin/ruby3.2"

# Install Ruby/Bundler deps
mamba run --prefix "$TMP_CONDA_PREFIX" --no-capture-output bundle install

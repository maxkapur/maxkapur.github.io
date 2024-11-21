#!/usr/bin/env bash

# Configure a workstation to build/develop the static site. Tested on Fedora
# Silverblue 40 and Ubuntu 22.04 (via GitHub Actions runner) with Miniforge.

# Remove existing .conda/ environment if it exists. Pipe yes to this script to
# automatically confirm.
TMP_CONDA_PREFIX=$(realpath "./.conda")
if [ -d "$TMP_CONDA_PREFIX" ]; then rm -ri "$TMP_CONDA_PREFIX"; fi

# Create conda environment. Set CI=True to prevent weird progress bar:
# https://github.com/mamba-org/mamba/issues/1478
CI="True" mamba create \
    --yes \
    --prefix "$TMP_CONDA_PREFIX" \
    --no-default-packages \
    --override-channels \
    --channel conda-forge \
    "compilers=1.8.*" \
    "make=4.*" \
    "ruby=3.3.*" \
    "shellcheck=0.10.*"

# Install Ruby/Bundler deps.
mamba run --prefix "$TMP_CONDA_PREFIX" --no-capture-output bundle install

#!/usr/bin/env bash

# Configure a workstation to build/develop the static site. Tested on Fedora
# Silverblue 40 and Ubuntu 22.04 (via GitHub Actions runner) with Miniforge.

# Ensure mamba installed
if ! [ -x "$(command -v mamba)" ]
then
    echo 'E: mamba not installed' >&2
    exit 1
fi

# Poor man's environment.yml to avoid cluttering the root directory
TMP_CONDA_DEPS=(
    "compilers=1.8.*"
    "make=4.*"
    "ruby=3.3.*"
    "shellcheck=0.10.*"
)

# Location of the conda environment
TMP_CONDA_PREFIX=$(realpath "./.conda")

# Set CI=True to prevent weird progress bar in mamba update/create:
# https://github.com/mamba-org/mamba/issues/1478
export CI="True"

# Check if we already have a ./.conda environment and update/create accordingly
if [ -d "$TMP_CONDA_PREFIX" ]
then
    # shellcheck disable=SC2068  # splitting intended
    mamba update \
        --yes \
        --prune \
        --prefix "$TMP_CONDA_PREFIX" \
        ${TMP_CONDA_DEPS[@]}
else
    # shellcheck disable=SC2068  # splitting intended
    mamba create \
        --yes \
        --prefix "$TMP_CONDA_PREFIX" \
        --no-default-packages \
        --override-channels \
        --channel conda-forge \
        ${TMP_CONDA_DEPS[@]}
fi

# Update/install Ruby/Bundler deps. Just as with the conda dependencies above,
# we do *not* force exact dependency resolution by checking Gemfile.lock into
# version control, and instead pin packages only to their minor versions in the
# Gemfile.
if [ -f "./Gemfile.lock" ]
then
    # Thus, if Gemfile.lock is present, bundle update --all to re-resolve deps.
    mamba run --prefix "$TMP_CONDA_PREFIX" --no-capture-output \
        bundle update --all
else
    mamba run --prefix "$TMP_CONDA_PREFIX" --no-capture-output \
        bundle install
fi

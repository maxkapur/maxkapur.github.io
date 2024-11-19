#!/usr/bin/env bash

# Configure a workstation to build/develop the static site. Tested on Ubuntu
# 22.04.

set -x
set -e

TMP_CONDA_PREFIX=$(realpath "./.conda")

# https://github.com/mamba-org/mamba/issues/1478
CI="True"

mkdir -p ./vendor/
if [ -d "$TMP_CONDA_PREFIX" ]; then rm -ri $TMP_CONDA_PREFIX; fi
mamba create \
    --yes \
    --prefix "$TMP_CONDA_PREFIX" \
    --no-default-packages \
    "conda-forge::compilers=1.8.*" \
    "conda-forge::make=4.*" \
    "conda-forge::ruby=3.2.*"
# Fixes issue where bundle looks for ruby3.2 instead of ruby
ln -s "$TMP_CONDA_PREFIX/bin/ruby" "$TMP_CONDA_PREFIX/bin/ruby3.2"
mamba run --prefix "$TMP_CONDA_PREFIX" --no-capture-output bundle install
# mamba run --prefix ./vendor/conda bundle exec jekyll serve

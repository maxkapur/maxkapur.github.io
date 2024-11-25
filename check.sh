#!/usr/bin/env bash

# Check shell scripts with Shellcheck
conda run --prefix ./.conda --no-capture-output \
    shellcheck ./*.sh

# Check links in built site
HTMLPROOFER_OPTIONS=("--disable-external")
# shellcheck disable=2068
conda run --prefix ./.conda --no-capture-output \
    bundle exec htmlproofer ${HTMLPROOFER_OPTIONS[@]} _site

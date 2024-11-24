#!/usr/bin/env bash

# Check shell scripts with Shellcheck
conda run --prefix ./.conda --no-capture-output \
    shellcheck ./*.sh

# Check links in built site
conda run --prefix ./.conda --no-capture-output \
    bundle exec htmlproofer ./_site

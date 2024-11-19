#!/usr/bin/env bash
conda run --prefix ./.conda --no-capture-output \
    bundle exec jekyll build "$@"

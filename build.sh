#!/usr/bin/env bash

source ./_scripts/common.sh
activate_conda_environment
bundle exec jekyll build "$@"

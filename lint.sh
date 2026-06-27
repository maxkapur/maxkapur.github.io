#!/usr/bin/env bash

set -ex

shellcheck ./*.sh
prettier . --check --verbose
ruff format --check
ruff check

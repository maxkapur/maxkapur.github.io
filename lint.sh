#!/usr/bin/env bash

set -ex

shellcheck ./*.sh
npx prettier . --check --verbose
ruff format --check
ruff check

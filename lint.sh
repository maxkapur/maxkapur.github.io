#!/usr/bin/env bash

set -ex

shellcheck ./*.sh
npx prettier . --check
ruff format --check
ruff check

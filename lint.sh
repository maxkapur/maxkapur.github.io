#!/usr/bin/env sh

set -ex

shellcheck ./*.sh
npx prettier . --check

#!/usr/bin/env bash

# Check that all installed conda packages are up to date
function check_conda_updated () {
    TEMP_FILE="$(mktemp)"
    mamba update --all --dry-run --json | tee "$TEMP_FILE"
    jq -e '.success and (.actions | length) == 0' "$TEMP_FILE"
}

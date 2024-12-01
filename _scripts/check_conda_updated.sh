#!/usr/bin/env bash

# Check that all installed conda packages are up to date
function check_conda_updated () {
    TEMP_FILE="$(mktemp)"
    conda update --all --dry-run | tee "$TEMP_FILE"
    # grep for the message that conda update prints if packages are up to date.
    # grep exits with 0 if it is not found (meaning that updates are available).
    grep -q "requested packages already installed" "$TEMP_FILE"
}

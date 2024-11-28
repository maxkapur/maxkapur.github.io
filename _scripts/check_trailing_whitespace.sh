#!/usr/bin/env bash

# Check that no committed text files have trailing whitespace
function check_trailing_whitespace () {
    BAD_FILES="$(git grep -IlE '\s$')"
    if [ -n "$BAD_FILES" ]
    then
        echo "$BAD_FILES" 1>&2
        error "Found source files with trailing whitespace"
        return 1
    fi
}

#!/usr/bin/env bash

# Check that Ruby packages from the Gemfile are up to date
function check_bundler_updated () {
    bundle outdated --only-explicit
}

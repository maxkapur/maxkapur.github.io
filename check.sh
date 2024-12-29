#!/usr/bin/env bash

source ./_scripts/common.sh
activate_conda_environment

header "Check shell scripts with ShellCheck"
SHELL_SCRIPTS=$(find . -maxdepth 2 -iname "*.sh")
echo "${SHELL_SCRIPTS[@]}" 1>&2
# shellcheck disable=2068  # splitting intended
shellcheck ${SHELL_SCRIPTS[@]} || exit $?

header "Check source files for trailing whitespace"
check_trailing_whitespace || exit $?

header "Check if packages up to date: conda"
check_conda_updated || exit $?

header "Check if packages up to date: bundler"
check_bundler_updated || exit $?

header "Check _site/ with HTML-Proofer"
echo "You may need to run ./build.sh first" 1>&2
HTMLPROOFER_OPTIONS=("--disable-external")
# shellcheck disable=2068  # splitting intended
bundle exec htmlproofer ${HTMLPROOFER_OPTIONS[@]} _site || exit $?

header "Check for deprecation warnings with Jekyll doctor"
bundle exec jekyll doctor || exit $?

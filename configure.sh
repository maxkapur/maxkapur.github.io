#!/usr/bin/env sh

# Configure a workstation to build/develop the static site. Tested on latest
# Ubuntu release.

set -x
if command -v git > /dev/null
then
    sudo apt update -y
    sudo apt upgrade -y
    sudo apt install -y rbenv ruby-build
else
    warn "OS is not Debian-based; skipped installing rbenv and ruby-build"
fi
eval "$(rbenv init -)"
rbenv install --skip-existing
bundle install
# bundle exec jekyll serve

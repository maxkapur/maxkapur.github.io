#!/usr/bin/env sh

# Configure a workstation to build/develop the static site. Tested on latest
# Ubuntu release.

set -x
sudo apt update -y
sudo apt upgrade -y
sudo apt install -y rbenv ruby-build
eval "$(rbenv init -)"
rbenv install --skip-existing
bundle install
# bundle exec jekyll serve

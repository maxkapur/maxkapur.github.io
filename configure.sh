#!/usr/bin/env bash

if command -v hugo >/dev/null
then
    echo "hugo already installed"
else
    sudo snap install hugo
fi

APT_PACKAGES=(npm python3-requests python3-saneyaml python3-tinycss2 python3-toml shellcheck)
if dpkg-query -l "${APT_PACKAGES[@]}" >/dev/null
then
    echo "apt packages already installed"
else
    sudo apt-get install "${APT_PACKAGES[@]}" --yes --quiet
fi

if npm ci --dry-run >/dev/null
then
    echo "npm packages already installed"
else
    npm install
fi

./themes/illusion-slopes/download_assets.py

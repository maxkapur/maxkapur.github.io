#!/usr/bin/env sh

if command -v hugo >/dev/null
then
    echo "hugo already installed"
else
    sudo snap install hugo
fi

./themes/illusion-slopes/download_assets.py

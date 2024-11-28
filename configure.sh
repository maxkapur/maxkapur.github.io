#!/usr/bin/env bash

# Configure a workstation to build/develop the static site. Tested on Fedora
# Silverblue 40 and Ubuntu 22.04 (via GitHub Actions runner) with Miniforge.

# This script is designed to minimize reduntant network requests by checking if
# downloaded files (such as those in assets/) already exist, but it is worth
# running git -fidx and then rerunning this script periodically to prevent local
# resources from becoming stale.

# Ensure mamba installed
if ! [ -x "$(command -v mamba)" ]
then
    echo 'E: mamba not installed' >&2
    exit 1
fi

# Poor man's environment.yml to avoid cluttering the root directory
TMP_CONDA_DEPS=(
    "compilers=1.8.*"
    "make=4.*"
    "ruby=3.3.*"
    "shellcheck=0.10.*"
)

# Location of the conda environment
TMP_CONDA_PREFIX=$(realpath "./.conda")

# Set CI=True to prevent weird progress bar in mamba update/create:
# https://github.com/mamba-org/mamba/issues/1478
export CI="True"

# Check if we already have a ./.conda environment and update/create accordingly
if [ -d "$TMP_CONDA_PREFIX" ]
then
    # shellcheck disable=SC2068  # splitting intended
    mamba update \
        --yes \
        --prune \
        --prefix "$TMP_CONDA_PREFIX" \
        ${TMP_CONDA_DEPS[@]}
else
    # shellcheck disable=SC2068  # splitting intended
    mamba create \
        --yes \
        --prefix "$TMP_CONDA_PREFIX" \
        --no-default-packages \
        --override-channels \
        --channel conda-forge \
        ${TMP_CONDA_DEPS[@]}
fi

# Update/install Ruby/Bundler deps. Just as with the conda dependencies above,
# we do *not* force exact dependency resolution by checking Gemfile.lock into
# version control, and instead pin packages only to their minor versions in the
# Gemfile.
if [ -f "./Gemfile.lock" ]
then
    # Thus, if Gemfile.lock is present, bundle update --all to re-resolve deps.
    mamba run --prefix "$TMP_CONDA_PREFIX" --no-capture-output \
        bundle update --all
else
    mamba run --prefix "$TMP_CONDA_PREFIX" --no-capture-output \
        bundle install
fi

echo "Populating assets/"

# Install IBM Plex fonts from GitHub releases

# IBM Plex uses a dual-versioning release scheme where they occasionally update
# a big monorepo with all the variants, and release more often updates to the
# individual variants. We only want the invididual variants specified below. To
# update the versions, go to https://github.com/IBM/plex/releases, search for
# the slug name (e.g. "plex-sans"), and select the release .zip from the assets
# associated with the newest version. (There are some slight inconsistencies
# with the exact tags and URLs.)
IBM_PLEX_MONO_SRC="https://github.com/IBM/plex/releases/download/%40ibm%2Fplex-mono%401.1.0/ibm-plex-mono.zip"
IBM_PLEX_SANS_SRC="https://github.com/IBM/plex/releases/download/%40ibm%2Fplex-sans%401.1.0/ibm-plex-sans.zip"
IBM_PLEX_SANS_KR_SRC="https://github.com/IBM/plex/releases/download/%40ibm%2Fplex-sans-kr%401.1.0/ibm-plex-sans-kr.zip"
IBM_PLEX_DEST="./assets/fonts"

function install_ibm_plex () {
    TEMPD=$(mktemp -d)
    curl -L -o "$TEMPD/ibm-plex-mono.zip" "$IBM_PLEX_SANS_SRC"
    curl -L -o "$TEMPD/ibm-plex-sans.zip" "$IBM_PLEX_SANS_KR_SRC"
    curl -L -o "$TEMPD/ibm-plex-sans-kr.zip" "$IBM_PLEX_MONO_SRC"

    ZIPS=$(ls "$TEMPD"/*.zip)
    # shellcheck disable=SC2068  # splitting intended
    for f in ${ZIPS[@]}
    do
        unzip -uoq "$f" -d "$IBM_PLEX_DEST"
    done

    # Remove SCSS source files from IBM, as they inflate the size of the build
    # for no reason: They are ignored by Jekyll's build pipeline, and we use the
    # compiled CSS files instead.
    echo "Removing IBM SCSS source files"
    rm -v "$IBM_PLEX_DEST"/ibm*/**/*.scss
}

if [ -d "$IBM_PLEX_DEST"/ibm-plex-mono ] \
    && [ -d "$IBM_PLEX_DEST"/ibm-plex-sans ] \
    && [ -d "$IBM_PLEX_DEST"/ibm-plex-sans-kr ]
then
    echo "IBM Plex fonts already present; use git clean to force reinstall"
else
    echo "Installing IBM Plex fonts"
    install_ibm_plex
fi

# Install KaTeX CSS and fonts

# Find katex.css and associated fonts installed to the vendor/ directory (by gem
# katex). Hardlink into the assets/ directory so that these files are included
# in the site build. Remove existing files to ensure clean update.
KATEX_CSS_SRC="$(find vendor/ -ipath "*/vendor/katex/stylesheets/katex.css")"
KATEX_CSS_DEST="./assets/katex.css"
rm "$KATEX_CSS_DEST" 2> /dev/null
if [ ! -f "$KATEX_CSS_SRC" ]
then
    echo "E: Failed to locate source katex.css" >&2
    exit 1
fi
ln -v "$KATEX_CSS_SRC" "$KATEX_CSS_DEST"

KATEX_FONTS_SRC=$(find vendor/ -ipath "*/vendor/katex/fonts/*.woff2")
KATEX_FONTS_DEST="./assets/fonts"
rm "$KATEX_FONTS_DEST"/*.woff2 2> /dev/null
# shellcheck disable=SC2068  # splitting intended
for f in ${KATEX_FONTS_SRC[@]}
do
    BASENAME=$(basename "$f")
    ln -v "$f" "$KATEX_FONTS_DEST"/"$BASENAME"
done

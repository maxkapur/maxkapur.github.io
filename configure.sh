#!/usr/bin/env bash

# Configure a workstation to build/develop the static site. Tested on Fedora
# Silverblue 40 and Ubuntu 22.04 (via GitHub Actions runner) with Miniforge.
#
# This script is designed to minimize reduntant network requests by checking if
# downloaded files (such as those in assets/) already exist, but it only checks
# the names of files, not their contents. Thus, it is worth periodically running
# `git clean -fidx` and then rerunning this script to prevent local resources
# from becoming stale.


source ./_scripts/common.sh || exit $?


header "Check that mamba is available"
if ! [ -x "$(command -v mamba)" ]
then
    error "mamba unavailable"
    exit 1
fi


# Check if we already have a ./.conda environment and update/create accordingly.
# NOTE: --prune flag to mamba update does not actually do anything; to remove a
# dependency from the installed environment, git clean then rerun the script.
function configure_conda_environment () {
    # Poor man's environment.yml to avoid cluttering the root directory
    CONDA_DEPS=(
        "compilers=1.8.*"
        "curl=8.10.*"
        "make=4.*"
        "ruby=3.3.*"
        "shellcheck=0.10.*"
        "unzip=6.0.*"
    )

    # Location of the conda environment
    CONDA_PREFIX=$(realpath "./.conda")

    # Set CI=True to prevent weird progress bar in mamba update/create:
    # https://github.com/mamba-org/mamba/issues/1478
    export CI="True"

    if [ -d "$CONDA_PREFIX" ]
    then
        # shellcheck disable=SC2068  # splitting intended
        mamba update \
            --yes \
            --prune \
            --prefix "$CONDA_PREFIX" \
            ${CONDA_DEPS[@]}
    else
        # shellcheck disable=SC2068  # splitting intended
        mamba create \
            --yes \
            --prefix "$CONDA_PREFIX" \
            --no-default-packages \
            --override-channels \
            --channel conda-forge \
            ${CONDA_DEPS[@]}
    fi
}

header "Configure conda environment (mamba install/update)"
configure_conda_environment || exit $?


header "Activate conda environment"
activate_conda_environment || exit $?


# Update/install Ruby/Bundler deps. Just as with the conda dependencies above,
# we do *not* force exact dependency resolution by checking Gemfile.lock into
# version control, and instead pin packages only to their minor versions in the
# Gemfile.
function configure_ruby_bundle () {
    if [ -f "./Gemfile.lock" ]
    then
        # Thus, if Gemfile.lock is present, bundle update --all to re-resolve deps.
        bundle update --all
    else
        bundle install
    fi
}

header "Configure Ruby dependencies (bundle install/update)"
configure_ruby_bundle || exit $?


# Install IBM Plex fonts from GitHub releases. IBM Plex uses a dual-versioning
# release scheme where they occasionally update a big monorepo with all the
# variants, and release more frequent updates to the individual variants. We
# only want the invididual variants specified below.
#
# To update the versions, go to https://github.com/IBM/plex/releases, search for
# the slug name (e.g. "plex-sans"), and select the release .zip from the assets
# associated with the newest version. (There are some slight inconsistencies
# with the exact tags and URLs.)
function install_ibm_plex () {
    IBM_PLEX_DEST="./assets/fonts"
    if [ -d "$IBM_PLEX_DEST"/ibm-plex-mono ] \
        && [ -d "$IBM_PLEX_DEST"/ibm-plex-sans ] \
        && [ -d "$IBM_PLEX_DEST"/ibm-plex-sans-kr ]
    then
        echo "IBM Plex fonts already present; use git clean to force reinstall" 1>&2
        return 0
    fi

    echo "Install IBM Plex fonts (curl)" 1>&2
    IBM_PLEX_MONO_SRC="https://github.com/IBM/plex/releases/download/%40ibm%2Fplex-mono%401.1.0/ibm-plex-mono.zip"
    IBM_PLEX_SANS_SRC="https://github.com/IBM/plex/releases/download/%40ibm%2Fplex-sans%401.1.0/ibm-plex-sans.zip"
    IBM_PLEX_SANS_KR_SRC="https://github.com/IBM/plex/releases/download/%40ibm%2Fplex-sans-kr%401.1.0/ibm-plex-sans-kr.zip"

    TEMPD=$(mktemp -d)
    curl -L -o "$TEMPD/ibm-plex-mono.zip" "$IBM_PLEX_SANS_SRC"
    curl -L -o "$TEMPD/ibm-plex-sans.zip" "$IBM_PLEX_SANS_KR_SRC"
    curl -L -o "$TEMPD/ibm-plex-sans-kr.zip" "$IBM_PLEX_MONO_SRC"

    echo "Install IBM Plex fonts (unzip)" 1>&2
    ZIPS=$(ls "$TEMPD"/*.zip)
    # shellcheck disable=SC2068  # splitting intended
    for f in ${ZIPS[@]}
    do
        unzip -uoq "$f" -d "$IBM_PLEX_DEST"
    done

    # Remove SCSS source files from IBM, as they inflate the size of the build
    # for no reason: They are ignored by Jekyll's build pipeline, and we use the
    # compiled CSS files instead.
    echo "Remove IBM SCSS source files" 1>&2
    rm -v "$IBM_PLEX_DEST"/ibm*/**/*.scss

    # Remove these versions of fonts as they are not referenced in the CSS.
    echo "Remove EOT and OTF font versions" 1>&2
    rm -v "$IBM_PLEX_DEST"/ibm*/**/*.eot
    rm -v "$IBM_PLEX_DEST"/ibm*/**/*.otf

    # IBM font LICENSE files are marked executable (probably compiled on
    # Windows); undo this.
    # shellcheck disable=SC2046  # splitting intended
    chmod a-x $(find "$IBM_PLEX_DEST" -type f)
}

header "Populate assets/: Verify/install IBM Plex fonts"
install_ibm_plex || exit $?


# Find katex.css and associated fonts installed to the vendor/ directory (by gem
# katex). Hardlink into the assets/ directory so that these files are included
# in the site build. Remove existing files to ensure clean update.
function install_katex_resources () {
    KATEX_CSS_SRC="$(find ./vendor/ -ipath "*/vendor/katex/stylesheets/katex.css")"
    KATEX_CSS_DEST="./assets/katex.css"
    rm "$KATEX_CSS_DEST" 2> /dev/null
    if [ ! -f "$KATEX_CSS_SRC" ]
    then
        echo "E: Failed to locate source katex.css" >&2
        exit 1
    fi
    ln -v "$KATEX_CSS_SRC" "$KATEX_CSS_DEST"

    KATEX_FONTS_SRC=$(find ./vendor/ -ipath "*/vendor/katex/fonts/*.woff2")
    KATEX_FONTS_DEST="./assets/fonts"
    rm "$KATEX_FONTS_DEST"/*.woff2 2> /dev/null
    # shellcheck disable=SC2068  # splitting intended
    for f in ${KATEX_FONTS_SRC[@]}
    do
        BASENAME=$(basename "$f")
        ln -v "$f" "$KATEX_FONTS_DEST"/"$BASENAME"
    done
}

header "Populate assets/: Install KaTeX CSS and fonts"
install_katex_resources || exit $?

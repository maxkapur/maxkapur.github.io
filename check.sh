#!/usr/bin/env bash

# Check shell scripts with Shellcheck
conda run --prefix ./.conda --no-capture-output \
    shellcheck ./*.sh

# Check links in built site. Build first if _site doesn't exist. Disabled
# because it gives too many false positives.

# if [ ! -d ./_site ]; then ./build.sh; fi
# conda run --prefix ./.conda --no-capture-output \
#     bundle exec htmlproofer ./_site

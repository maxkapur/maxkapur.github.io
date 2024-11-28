#!/usr/bin/env bash

source ./_scripts/common.sh
activate_conda_environment

header "conda info"
conda info
header "conda list"
conda list
header "bundle list"
bundle list

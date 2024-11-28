#!/usr/bin/env bash
function activate_conda_environment () {
    eval "$(conda shell.bash hook)"
    conda activate ./.conda
}

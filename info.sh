#!/usr/bin/env bash
conda run --prefix ./.conda --no-capture-output conda info
conda run --prefix ./.conda --no-capture-output conda list
conda run --prefix ./.conda --no-capture-output bundle list

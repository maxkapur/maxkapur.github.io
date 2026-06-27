#!/usr/bin/env sh
if [ $# -eq 0 ]
then
  nix --extra-experimental-features nix-command --extra-experimental-features flakes develop
else
  nix --extra-experimental-features nix-command --extra-experimental-features flakes develop --command "$@"
fi

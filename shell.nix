let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-26.05";
  pkgs = import nixpkgs { config = {}; overlays = []; };
in

pkgs.mkShellNoCC {
  packages = with pkgs; [
    hugo
    prettier
    prettier-plugin-go-template
    python3
    python313Packages.requests
    python313Packages.ruff
    python313Packages.saneyaml
    python313Packages.tinycss2
    python313Packages.toml
    shellcheck
  ];
}

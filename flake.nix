{
  description = "Dev shell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-26.05";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShells.x86_64-linux.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          htmltest
          hugo
          nixfmt
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
        shellHook = ''
          cat > .prettierrc << EOF
          {
            "plugins": ["${pkgs.prettier-plugin-go-template}/lib/node_modules/prettier-plugin-go-template/lib/index.js"],
            "overrides": [
              {
                "files": ["*.html", "*.xml"],
                "options": {
                  "parser": "go-template"
                }
              }
            ]
          }
          EOF
          ./themes/illusion-slopes/download_assets.py >/dev/null
          echo "Dev shell initialized from flake.nix"
        '';
      };
    };
}

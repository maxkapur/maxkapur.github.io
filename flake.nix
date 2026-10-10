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
          python315
          python315Packages.mdformat
          python315Packages.requests
          python315Packages.ruff
          python315Packages.saneyaml
          python315Packages.tinycss2
          python315Packages.toml
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
          cat > pyproject.toml << EOF
          [project]
          requires-python = "== 3"
          EOF
          ./themes/illusion-slopes/download_assets.py >/dev/null
          echo "Dev shell initialized from flake.nix"
        '';
      };
    };
}

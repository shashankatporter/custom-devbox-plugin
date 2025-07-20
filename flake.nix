{
  description = "Devbox-like plugin flake: Node.js + MongoDB + Custom Hook";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in {
        devShells.default = pkgs.mkShell {
          packages = [];
          shellHook = ''
            export MY_PLUGIN_VAR="Injected from flake"
            # Example copying config (optional)
            if [ ! -f ./config/my-plugin.conf ]; then
              cp ${./config/my-plugin.conf} ./config/my-plugin.conf
            fi
            # Call additional hook
            source ${./scripts/my-plugin-hook.sh}
            echo "Devbox-like Nix flake shell is ready"
          '';
        };
        packages = {
          default = pkgs.stdenv.mkDerivation {
            name = "custom-devbox-plugin";
            src = ./.;
            buildPhase = "true";
            installPhase = "mkdir -p $out";
          };
        };
      }
    );
}

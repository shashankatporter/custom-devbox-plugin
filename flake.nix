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
            # --- Plugin env ---
            export MY_PLUGIN_VAR="Injected from flake"
            # (Add more plugin env vars here)

            # --- User env ---
            if [ -f ./config/user-env.sh ]; then
              source ./config/user-env.sh
            fi
            # (User can add their own env vars in ./config/user-env.sh)

            # --- Plugin init_hook ---
            if [ ! -f ./config/my-plugin.conf ]; then
              cp ${./config/my-plugin.conf} ./config/my-plugin.conf
            fi
            source ${./scripts/my-plugin-hook.sh}

            # --- User init hook ---
            if [ -f ./config/user-init-hook.sh ]; then
              source ./config/user-init-hook.sh
            fi

            # --- Start Shell (entrypoint) ---
            echo "Devbox-like Nix flake shell is ready"
            if [ -n "$RUN_SCRIPTS" ]; then
              echo "[INFO] Running user scripts: $RUN_SCRIPTS"
              eval "$RUN_SCRIPTS"
              exit $?
            fi
            if [ -n "$START_SERVICES" ]; then
              echo "[INFO] Starting services: $START_SERVICES"
              eval "$START_SERVICES"
              exit $?
            fi
            # Otherwise, drop into interactive shell
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

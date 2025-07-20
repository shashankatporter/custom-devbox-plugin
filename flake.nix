{
  description = "Porter plugin collection for Local Development";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }:
    let
      # Support multiple systems
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
    in {
      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
          
          lintApp = pkgs.writeShellApplication {
            name = "linter";
            runtimeInputs = [
              pkgs.shellcheck
              # Add other dependencies as needed
            ];
            text = builtins.readFile ./scripts/linter.sh;
          };
        in {
          linter = lintApp;
          default = lintApp;  # Makes it accessible as #default too
        });

      apps = forAllSystems (system: {
        linter = {
          type = "app";
          program = "${self.packages.${system}.linter}/bin/linter";
        };
        default = {
          type = "app";
          program = "${self.packages.${system}.linter}/bin/linter";
        };
      });
    };
}

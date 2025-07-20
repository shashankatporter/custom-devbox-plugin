{
  description = "Porter plugin collection for Local Development";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f {
        pkgs = nixpkgs.legacyPackages.${system};
        inherit system;
      });
    in {
      packages = forAllSystems ({ pkgs, system }: {
        linter = pkgs.writeShellApplication {
          name = "linter";
          runtimeInputs = [ pkgs.shellcheck ];
          text = builtins.readFile ./scripts/linter.sh;
        };
      });

      apps = forAllSystems ({ pkgs, system }: {
        linter = {
          type = "app";
          program = "${self.packages.${system}.linter}/bin/linter";
        };
      });

      devboxPlugins = forAllSystems ({ pkgs, system }: {
        linter = {
          package = self.packages.${system}.linter;
          init_hook = "echo '✅ Porter linter ready! Run linter to use.'";
        };
      });
    };
}

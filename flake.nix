{
  description = "Porter Custom Devbox Plugins";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      pkgsFor = forAllSystems (system: import nixpkgs { inherit system; });

      makePluginPackage = pkgs: name: scriptPath: 
        pkgs.writeShellScriptBin name (builtins.readFile scriptPath);

      allToolsFor = system:
        let pkgs = pkgsFor.${system};
        in {
          org-linter = makePluginPackage pkgs "org-linter" ./scripts/org-linter.sh;
          db-seeder = makePluginPackage pkgs "db-seeder" ./scripts/db-seeder.sh;
        };

    in
    {
      packages = forAllSystems (system:
        let
          pkgs = pkgsFor.${system};
          tools = allToolsFor system;
        in
        tools // {
          porter-tools = pkgs.symlinkJoin {
            name = "porter-tools";
            paths = [ tools.org-linter tools.db-seeder ];
          };
          default = self.packages.${system}.porter-tools;
        }
      );

      devboxPlugins = forAllSystems (system: {
        default = {
          package = self.packages.${system}.porter-tools;
          
          # NEW: Use create_files instead of init_hook for robustness.
          create_files = {
            # This creates a file at .devbox/gen/porter-startup.sh
            ".devbox/gen/porter-startup.sh" = ''
              #!/bin/sh
              echo "--- Running Porter startup scripts ---"
              db-seeder
              org-linter
              echo "--- Startup scripts complete ---"
            '';
          };
        };
      });
    };
}
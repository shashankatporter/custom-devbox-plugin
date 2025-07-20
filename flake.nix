{
  description = "Porter Custom Devbox Plugins";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      pkgsFor = forAllSystems (system: import nixpkgs { inherit system; });

      # Helper to create a package by reading a script file
      makePluginPackage = pkgs: name: scriptPath: 
        pkgs.writeShellScriptBin name (builtins.readFile scriptPath);

      # Build individual tool packages for a given system
      allToolsFor = system:
        let pkgs = pkgsFor.${system};
        in {
          org-linter = makePluginPackage pkgs "org-linter" ./scripts/org-linter.sh;
          db-seeder = makePluginPackage pkgs "db-seeder" ./scripts/db-seeder.sh;
        };

    in
    {
      # This output contains all packages, including the new combined one
      packages = forAllSystems (system:
        let
          pkgs = pkgsFor.${system};
          tools = allToolsFor system;
        in
        tools // {
          # This single package combines both tools using symlinks.
          porter-tools = pkgs.symlinkJoin {
            name = "porter-tools";
            paths = [ tools.org-linter tools.db-seeder ];
          };

          # IMPORTANT: This makes "porter-tools" the default package for this flake.
          default = self.packages.${system}.porter-tools;
        }
      );

      # This output now provides a single, default plugin for Devbox
      devboxPlugins = forAllSystems (system: {
        # Devbox uses this "default" when you add the flake URL without a #fragment.
        default = {
          package = self.packages.${system}.porter-tools;
          
          # MODIFIED: The init_hook is now a multi-line script that runs both commands.
          # The '' (two single quotes) syntax is how you create multi-line strings in Nix.
          init_hook = ''
            echo "--- Running Porter startup scripts ---"
            db-seeder
            org-linter
            echo "--- Startup scripts complete ---"
          '';
        };
      });
    };
}
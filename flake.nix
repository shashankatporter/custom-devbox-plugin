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
          porter-tools-pkg = pkgs.symlinkJoin {
            name = "porter-tools";
            paths = [ tools.org-linter tools.db-seeder ];
          };
        in
        # CORRECTED: Define startup-script at the top level of this set.
        {
          inherit (tools) org-linter db-seeder; # Keep these individual packages
          porter-tools = porter-tools-pkg;
          default = porter-tools-pkg;

          startup-script = pkgs.writeTextFile {
            name = "porter-startup.sh";
            text = ''
              #!/bin/sh
              echo "--- Running Porter startup scripts ---"
              db-seeder
              org-linter
              echo "--- Startup scripts complete ---"
            '';
          };
        }
      );
    };
}
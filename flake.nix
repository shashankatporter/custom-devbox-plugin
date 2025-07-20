{
  description = "Porter Custom Devbox Plugins";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      pkgsFor = forAllSystems (system: import nixpkgs { inherit system; });

      # Define the plugins data structure with paths to the scripts
      pluginsData = {
        org-linter = {
          latest = ./scripts/org-linter.sh;
        };
        db-seeder = {
          latest = ./scripts/db-seeder.sh;
        };
      };

      # Helper to create a package by reading a script file
      makePluginPackage = pkgs: name: scriptPath: 
        pkgs.writeShellScriptBin name (builtins.readFile scriptPath);
      
      # Build all packages for a given system
      allPackagesFor = system:
        let
          pkgs = pkgsFor.${system};
          makePackagesFromVersions = pluginName: versions:
            builtins.listToAttrs (map (version: {
              name = pluginName; # Simplified to just use the plugin name
              value = makePluginPackage pkgs pluginName versions.${version};
            }) (builtins.attrNames versions));
        in
        (makePackagesFromVersions "org-linter" pluginsData.org-linter) //
        (makePackagesFromVersions "db-seeder" pluginsData.db-seeder);

    in
    {
      packages = forAllSystems allPackagesFor;

      # Expose them as Devbox plugins
      devboxPlugins = forAllSystems (system:
        let
          systemPackages = allPackagesFor system;
        in
        {
          # The linter just provides a ready message
          org-linter = {
            package = systemPackages.org-linter;
            init_hook = "echo '✅ Porter org-linter ready! Run org-linter to use.'";
          };

          # The seeder will run automatically every time you start the shell
          db-seeder = {
            package = systemPackages.db-seeder;
            init_hook = "db-seeder"; # This calls the script!
          };
        }
      );
    };
}
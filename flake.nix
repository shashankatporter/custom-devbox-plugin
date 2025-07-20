{
  description = "Porter Custom Devbox Plugins";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      pkgsFor = forAllSystems (system: import nixpkgs { inherit system; });

      # Define the plugins data structure
      pluginsData = {
        org-linter = {
          "1-0-0" = "echo 'Running organization linter v1.0.0...'; echo '✅ Linting complete!'";
          latest = "echo 'Running organization linter...'; echo '✅ Linting complete!'";
        };
        db-seeder = {
          "1-0-0" = "echo 'Running database seeder v1.0.0...'; echo '✅ Seeding complete!'";
          latest = "echo 'Running database seeder...'; echo '✅ Seeding complete!'";
        };
      };

      # Helper to create a single package from a script
      makePluginPackage = pkgs: name: version: script: 
        pkgs.writeShellScriptBin name ''
          echo "🔧 Porter ${name} v${version}"
          ${script}
        '';
      
      # Build all packages for a given system
      allPackagesFor = system:
        let
          pkgs = pkgsFor.${system};
          # Turn a set of versions into a set of packages
          makePackagesFromVersions = pluginName: versions:
            builtins.listToAttrs (map (version: {
              # e.g., name = "org-linter" or "org-linter-v1-0-0"
              name = if version == "latest" then pluginName else "${pluginName}-v${version}";
              value = makePluginPackage pkgs pluginName version versions.${version};
            }) (builtins.attrNames versions));
        in
        # Merge the packages for all plugins
        (makePackagesFromVersions "org-linter" pluginsData.org-linter) //
        (makePackagesFromVersions "db-seeder" pluginsData.db-seeder);

    in
    {
      # Expose the packages directly
      packages = forAllSystems allPackagesFor;

      # Expose them as Devbox plugins, referencing the already-built packages
      devboxPlugins = forAllSystems (system:
        let
          # Get the packages we already built for this system
          systemPackages = allPackagesFor system;
        in
          # Map over the packages to add the devbox-specific attributes like init_hook
          nixpkgs.lib.mapAttrs (name: pkg: {
            # Reference the package instead of rebuilding it
            package = pkg;
            init_hook = "echo '✅ Porter plugin ${name} ready! Run ${name} to use.'";
          }) systemPackages
      );
    };
}
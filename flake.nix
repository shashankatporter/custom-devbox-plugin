{
  description = "Porter Custom Devbox Plugins";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      pkgsFor = forAllSystems (system: import nixpkgs { inherit system; });

      makePlugin = pkgs: name: version: script: 
        pkgs.writeShellScriptBin name ''
          echo "🔧 Porter ${name} v${version}"
          ${script}
        '';

      plugins = {
        org-linter = {
          "1.0.0" = "echo 'Running basic linting...'; echo '✅ Basic linting complete!'";
          "1.1.0" = "echo 'Running enhanced linting...'; echo '📁 Checking structure...'; echo '✅ Enhanced linting complete!'";
          "1.2.0" = "echo 'Running advanced linting...'; echo '📁 Checking structure...'; echo '🔍 Analyzing files...'; echo '✅ Advanced linting complete!'";
          latest = "echo 'Running latest linting...'; echo '📁 Checking structure...'; echo '🔍 Analyzing files...'; echo '📊 Generating report...'; echo '✅ Latest linting complete!'";
        };
        db-seeder = {
          "1.0.0" = "echo 'Running basic seeding...'; echo '✅ Basic seeding complete!'";
          "2.0.0" = "echo 'Running enhanced seeding...'; echo '🗄️ Multi-database support...'; echo '✅ Enhanced seeding complete!'";
          "2.1.0" = "echo 'Running advanced seeding...'; echo '🗄️ MySQL, PostgreSQL, MongoDB...'; echo '⚡ Parallel processing...'; echo '✅ Advanced seeding complete!'";
          latest = "echo 'Running latest seeding...'; echo '🗄️ All databases supported...'; echo '⚡ Parallel processing...'; echo '📊 Real-time tracking...'; echo '✅ Latest seeding complete!'";
        };
      };

    in {
      packages = forAllSystems (system:
        let 
          pkgs = pkgsFor.${system};
          mkVersions = name: versions: builtins.listToAttrs (map (version: {
            name = if version == "latest" then name else "${name}-v${version}";
            value = makePlugin pkgs name version versions.${version};
          }) (builtins.attrNames versions));
        in
        (mkVersions "org-linter" plugins.org-linter) //
        (mkVersions "db-seeder" plugins.db-seeder)
      );

      devboxPlugins = forAllSystems (system:
        let 
          pkgs = pkgsFor.${system};
          mkPlugins = name: versions: builtins.listToAttrs (map (version: {
            name = if version == "latest" then name else "${name}-v${version}";
            value = {
              package = makePlugin pkgs name version versions.${version};
              init_hook = "echo '✅ Porter ${name} v${version} ready! Run ${name} to use.'";
            };
          }) (builtins.attrNames versions));
        in
        (mkPlugins "org-linter" plugins.org-linter) //
        (mkPlugins "db-seeder" plugins.db-seeder)
      );
    };
}

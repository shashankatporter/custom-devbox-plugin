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
          "1-0-0" = "echo 'Running organization linter v1.0.0...'; echo '✅ Linting complete!'";
          latest = "echo 'Running organization linter...'; echo '✅ Linting complete!'";
        };
        db-seeder = {
          "1-0-0" = "echo 'Running database seeder v1.0.0...'; echo '✅ Seeding complete!'";
          latest = "echo 'Running database seeder...'; echo '✅ Seeding complete!'";
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
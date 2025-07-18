{
  description = "Porter Custom Devbox Plugins - Centralized plugin repository for Porter organization";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      pkgsFor = forAllSystems (system: import nixpkgs { inherit system; });

      # Plugin creator function
      makePlugin = pkgs: name: version: script: 
        pkgs.writeShellScriptBin name ''
          #!/bin/bash
          echo "🔧 Porter ${name} v${version}"
          ${script}
        '';

      # Plugin definitions - each with multiple versions
      plugins = {
        org-linter = {
          "1.0.0" = ''
            echo "Running basic organization linter..."
            echo "✅ Basic linting complete!"
          '';
          "1.1.0" = ''
            echo "Running enhanced organization linter..."
            echo "📁 Checking project structure..."
            echo "✅ Enhanced linting complete!"
          '';
          "1.2.0" = ''
            echo "Running advanced organization linter..."
            echo "📁 Checking project structure..."
            echo "🔍 Analyzing multiple file types..."
            echo "✅ Advanced linting complete!"
          '';
          latest = ''
            echo "Running latest organization linter..."
            echo "📁 Checking project structure..."
            echo "🔍 Analyzing multiple file types..."
            echo "📊 Generating JSON report..."
            echo "✅ Latest linting complete!"
          '';
        };

        db-seeder = {
          "1.0.0" = ''
            echo "Running basic database seeder..."
            echo "✅ Basic seeding complete!"
          '';
          "2.0.0" = ''
            echo "Running enhanced database seeder..."
            echo "🗄️  Supporting multiple databases..."
            echo "✅ Enhanced seeding complete!"
          '';
          "2.1.0" = ''
            echo "Running advanced database seeder..."
            echo "🗄️  Supporting MySQL, PostgreSQL, and MongoDB..."
            echo "⚡ Parallel seeding enabled..."
            echo "📊 Progress indicators active..."
            echo "✅ Advanced seeding complete!"
          '';
          latest = ''
            echo "Running latest database seeder..."
            echo "🗄️  Supporting all major databases..."
            echo "⚡ Parallel processing enabled..."
            echo "📊 Real-time progress tracking..."
            echo "🔧 Configuration validation..."
            echo "✅ Latest seeding complete!"
          '';
        };
      };

    in
    {
      # Packages for devbox compatibility
      packages = forAllSystems (system:
        let 
          pkgs = pkgsFor.${system};
          
          # Generate all plugin versions as packages
          generatePluginPackages = pluginName: versions:
            builtins.listToAttrs (map (version: {
              name = if version == "latest" then pluginName else "${pluginName}-v${version}";
              value = makePlugin pkgs pluginName version versions.${version};
            }) (builtins.attrNames versions));
            
        in
        # Create all plugin packages
        (generatePluginPackages "org-linter" plugins.org-linter) //
        (generatePluginPackages "db-seeder" plugins.db-seeder)
      );

      # Main devbox plugins output
      devboxPlugins = forAllSystems (system:
        let 
          pkgs = pkgsFor.${system};
          
          # Generate all plugin versions
          generatePluginVersions = pluginName: versions:
            builtins.listToAttrs (map (version: {
              name = if version == "latest" then pluginName else "${pluginName}-v${version}";
              value = {
                package = makePlugin pkgs pluginName version versions.${version};
                init_hook = ''
                  echo "✅ Porter ${pluginName} v${version} is ready!"
                  echo "   Run '${pluginName}' to use this tool."
                '';
              };
            }) (builtins.attrNames versions));
            
        in
        # Create all plugin versions
        (generatePluginVersions "org-linter" plugins.org-linter) //
        (generatePluginVersions "db-seeder" plugins.db-seeder)
      );
    };
}

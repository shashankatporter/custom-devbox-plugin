# flake.nix
{
  description = "Porter Devbox Plugins with Clean Version Management";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      pkgsFor = forAllSystems (system: import nixpkgs { inherit system; });

      # Plugin definitions with versions
      makePlugin = pkgs: name: version: script: 
        pkgs.writeShellScriptBin name ''
          #!/bin/sh
          echo "🔧 Porter ${name} v${version}"
          ${script}
        '';

      # Define plugin versions and their implementations
      pluginVersions = {
        org-linter = {
          "v1.0.0" = ''
            echo "Running basic organization linter..."
            echo "✅ Basic linting complete!"
          '';
          "v1.1.0" = ''
            echo "Running organization linter with improved features..."
            echo "📝 Checking configuration files..."
            echo "✅ Enhanced linting complete!"
          '';
          "v1.2.0" = ''
            echo "Running advanced organization linter..."
            echo "📁 Checking project structure..."
            echo "🔍 Analyzing multiple file types..."
            echo "✅ Advanced linting complete!"
          '';
          "latest" = ''
            echo "Running latest organization linter..."
            echo "📁 Checking project structure..."
            echo "🔍 Analyzing multiple file types..."
            echo "📊 Generating JSON report..."
            echo "✅ Latest linting complete!"
          '';
        };
        db-seeder = {
          "v1.0.0" = ''
            echo "Running basic database seeder..."
            echo "�️  Seeding MySQL database..."
            echo "✅ Basic seeding complete!"
          '';
          "v2.0.0" = ''
            echo "Running multi-database seeder..."
            echo "🗄️  Supporting MySQL and PostgreSQL..."
            echo "🔄 Environment-specific configurations..."
            echo "✅ Multi-database seeding complete!"
          '';
          "v2.1.0" = ''
            echo "Running advanced database seeder..."
            echo "🗄️  Supporting MySQL, PostgreSQL, and MongoDB..."
            echo "⚡ Parallel seeding enabled..."
            echo "📊 Progress indicators active..."
            echo "✅ Advanced seeding complete!"
          '';
          "latest" = ''
            echo "Running latest database seeder..."
            echo "🗄️  Supporting all major databases..."
            echo "⚡ Parallel seeding with optimization..."
            echo "📊 Real-time progress tracking..."
            echo "✅ Latest seeding complete!"
          '';
        };
      };
    in
    {
      packages = forAllSystems (system:
        let 
          pkgs = pkgsFor.${system};
          
          # Generate packages for each plugin version
          generateVersionedPackages = pluginName: versions:
            builtins.listToAttrs (map (version: {
              name = "${pluginName}-${version}";
              value = makePlugin pkgs pluginName version versions.${version};
            }) (builtins.attrNames versions));
          
        in
        # Create all versioned packages
        (generateVersionedPackages "org-linter" pluginVersions.org-linter) //
        (generateVersionedPackages "db-seeder" pluginVersions.db-seeder) //
        {
          # Also provide non-versioned (latest) packages
          org-linter = makePlugin pkgs "org-linter" "latest" pluginVersions.org-linter.latest;
          db-seeder = makePlugin pkgs "db-seeder" "latest" pluginVersions.db-seeder.latest;
        }
      );

      devboxPlugins = forAllSystems (system:
        let 
          packages = self.packages.${system};
          
          # Create plugin entries for each version
          generateVersionedPlugins = pluginName: versions:
            builtins.listToAttrs (map (version: {
              name = "${pluginName}-${version}";
              value = {
                package = packages."${pluginName}-${version}";
                init_hook = ''
                  echo "✅ Porter ${pluginName} ${version} is ready!"
                  echo "   Run '${pluginName}' to use this tool."
                '';
              };
            }) (builtins.attrNames versions));
            
        in
        # Create all versioned plugin definitions
        (generateVersionedPlugins "org-linter" pluginVersions.org-linter) //
        (generateVersionedPlugins "db-seeder" pluginVersions.db-seeder) //
        {
          # Default (latest) versions
          org-linter = {
            package = packages.org-linter;
            init_hook = ''
              echo "✅ Porter org-linter (latest) is ready!"
              echo "   Run 'org-linter' to use this tool."
            '';
          };
          db-seeder = {
            package = packages.db-seeder;
            init_hook = ''
              echo "✅ Porter db-seeder (latest) is ready!"
              echo "   Run 'db-seeder' to use this tool."
            '';
          };
        }
      );
    };
}
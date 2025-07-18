{
  description = "Custom Devbox plugins for Porter organization";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        
        # Import the plugin builder library
        pluginBuilder = import ./lib/plugin-builder.nix { inherit pkgs; };
        
        # Import the plugin registry
        registry = import ./registry/index.nix;
        
        # Function to load a plugin from the registry
        loadPlugin = category: pluginName:
          let
            pluginInfo = registry.${category}.${pluginName};
            pluginModule = import pluginInfo.path { inherit pkgs pluginBuilder; };
          in pluginModule;
        
        # Load all plugins from registry
        plugins = {
          org-linter = loadPlugin "development" "org-linter";
          db-seeder = loadPlugin "development" "db-seeder";
        };
      in
      {
        # Devbox plugins output
        devboxPlugins = plugins;
        
        # Packages output for direct installation
        packages = {
          orglinter = pluginBuilder.makePluginPackage plugins.org-linter;
          dbseeder = pluginBuilder.makePluginPackage plugins.db-seeder;
        };
      }
    );
}
            echo "Ready to lint your Porter organization code!"
          '';
        };
        db-seeder = {
          "1.0.0" = ''
            echo "Available database tools:"
            echo "  - PostgreSQL (psql)"
            echo "  - MySQL 8.0 (mysql)"
            echo "  - Redis (redis-cli)"
            echo "  - Node.js 20 (for JS seeders)"
            echo "  - Python 3.11 (for Python seeders)"
            echo ""
            
            # Create database management aliases
            alias db-setup="echo 'Setting up database environment...' && echo 'Configure your database connection and run setup scripts'"
            alias db-seed="echo 'Seeding database...' && echo 'Run your data seeding scripts'"
            alias db-reset="echo 'Resetting database...' && echo 'Clear and reset database to initial state'"
            alias db-migrate="echo 'Running migrations...' && echo 'Apply database schema migrations'"
            alias db-status="echo 'Database status:' && ps aux | grep -E '(postgres|mysql|redis)' | grep -v grep || echo 'No database processes found'"
            
            echo "Usage:"
            echo "  db-setup    - Setup database environment"
            echo "  db-seed     - Seed database with data"
            echo "  db-reset    - Reset database"
            echo "  db-migrate  - Run migrations"
            echo "  db-status   - Check database processes"
            echo ""
            echo "Ready to manage your Porter databases!"
          '';
        };
      };

    in {
      packages = forAllSystems (system:
        let 
          pkgs = pkgsFor.${system};
          mkVersions = name: versions: 
            builtins.listToAttrs (map (version: 
              let
                attrName = "${name}-v${builtins.replaceStrings ["."] ["-"] version}";
              in {
                name = attrName;
                value = makePlugin pkgs name version versions.${version};
              }
            ) (builtins.attrNames versions));
        in
          (mkVersions "org-linter" plugins.org-linter) //
          (mkVersions "db-seeder" plugins.db-seeder)
      );
      
      devShells = forAllSystems (system: {
        default = pkgsFor.${system}.mkShell {
          buildInputs = with pkgsFor.${system}; [
            bash
            jq
            git
          ];
          
          shellHook = ''
            echo "Porter Plugin Development Environment - Fixed Modular Architecture"
            echo "=================================================================="
            echo ""
            echo "Available Plugins:"
            echo "  - org-linter v1.0.0  - Organization code linting tools"
            echo "  - db-seeder v1.0.0   - Database seeding and management"
            echo ""
            echo "Binary Names:"
            echo "  orglinter  - org-linter plugin (hyphens removed)"
            echo "  dbseeder   - db-seeder plugin (hyphens removed)"
            echo ""
            echo "Test with:"
            echo '  {"packages": ["git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git#org-linter-v1-0-0"]}'
            echo ""
            echo "Fixed modular architecture with proper Nix syntax!"
          '';
        };
      });
    };
}

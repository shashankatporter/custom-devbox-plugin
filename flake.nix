{
  description = "Porter Custom Devbox Plugins - Modular Architecture";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        
        # Helper function to format version strings for attribute names
        formatVersion = version: builtins.replaceStrings ["."] ["-"] version;
        
        # Simple plugin builder that mimics the working version
        makePlugin = name: version: shellInit: 
          pkgs.writeShellScriptBin name ''
            echo "🔧 Porter ${name} v${version}"
            ${shellInit}
          '';
        
        # Define plugins using modular structure but simplified
        plugins = {
          org-linter = {
            "1.0.0" = makePlugin "porter-linter" "1.0.0" ''
              echo "🔍 Porter Org Linter v1.0.0 initialized"
              echo "Available linting tools:"
              echo "  - eslint (JavaScript/TypeScript)"
              echo "  - prettier (Code formatting)"
              echo "  - golangci-lint (Go)"
              echo "  - shellcheck (Shell scripts)"
              echo "  - yamllint (YAML files)"
              
              # Add linting aliases
              alias lint-js="eslint --ext .js,.ts,.jsx,.tsx"
              alias lint-go="golangci-lint run"
              alias lint-shell="find . -name '*.sh' -exec shellcheck {} \;"
              alias lint-yaml="yamllint ."
              alias lint-all="lint-js . && lint-go && lint-shell && lint-yaml"
              
              echo "Use 'lint-all' to run all linters or individual commands like 'lint-js', 'lint-go', etc."
              echo "Note: Command name is 'porter-linter' (with hyphen, but different name)"
            '';
          };
          db-seeder = {
            "1.0.0" = makePlugin "db-seeder" "1.0.0" ''
              echo "🌱 Porter DB Seeder v1.0.0 initialized"
              echo "Available database tools:"
              echo "  - PostgreSQL (psql)"
              echo "  - MySQL 8.0 (mysql)"
              echo "  - Redis (redis-cli)"
              echo "  - Node.js 20 (for JS seeders)"
              echo "  - Python 3.11 (for Python seeders)"
              
              # Add seeding aliases
              alias db-setup="echo 'Setting up database...' && echo 'Run your setup script'"
              alias db-seed="echo 'Seeding database...' && echo 'Run your seed script'"
              alias db-reset="echo 'Resetting database...' && echo 'Run your reset script'"
              alias db-migrate="echo 'Running migrations...' && echo 'Run your migration script'"
              alias db-status="echo 'Database status:' && ps aux | grep -E '(postgres|mysql|redis)'"
              
              echo "Use 'db-setup', 'db-seed', 'db-reset', 'db-migrate', or 'db-status'"
            '';
          };
        };
        
        # Create packages output similar to the working version
        mkVersions = name: versions: 
          builtins.listToAttrs (map (version: 
            let
              attrName = "${name}-v${formatVersion version}";
            in {
              name = attrName;
              value = versions.${version};
            }
          ) (builtins.attrNames versions));
            
      in {
        # Package outputs
        packages = 
          (mkVersions "org-linter" plugins.org-linter) //
          (mkVersions "db-seeder" plugins.db-seeder);
        
        # Development tools
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            bash
            jq
          ];
          
          shellHook = ''
            echo "🔧 Porter Plugin Development Environment - Modular Architecture"
            echo "============================================================="
            echo
            echo "Available commands:"
            echo "  ./scripts/add-plugin.sh      - Add a new plugin"
            echo "  ./scripts/update-version.sh  - Manage plugin versions"
            echo
            echo "Available Plugins:"
            echo "  org-linter v1.0.0"
            echo "  db-seeder v1.0.0"
            echo
            echo "Test plugins with:"
            echo "  echo 'org-linter' | devbox shell"
            echo "  echo 'db-seeder' | devbox shell"
            echo
          '';
        };
      }
    );
}

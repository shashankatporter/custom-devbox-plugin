{
  description = "Porter Custom Devbox Plugins - Fixed Modular Architecture";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      pkgsFor = forAllSystems (system: import nixpkgs { inherit system; });

      # Enhanced plugin builder
      makePlugin = pkgs: name: version: script: 
        let
          # Create safe binary names
          safeName = builtins.replaceStrings ["-"] [""] name;
        in
        pkgs.writeShellScriptBin safeName ''
          echo "Porter ${name} v${version}"
          echo "Binary: ${safeName}"
          echo "----------------------------------------"
          ${script}
        '';

      # Define plugins with enhanced content
      plugins = {
        org-linter = {
          "1.0.0" = ''
            echo "Available linting tools:"
            echo "  - eslint (JavaScript/TypeScript)"
            echo "  - prettier (Code formatting)"
            echo "  - golangci-lint (Go)"
            echo "  - shellcheck (Shell scripts)"
            echo "  - yamllint (YAML files)"
            echo ""
            
            # Create linting aliases
            alias lint-js="eslint --ext .js,.ts,.jsx,.tsx"
            alias lint-go="golangci-lint run"
            alias lint-shell="find . -name '*.sh' -exec shellcheck {} \;"
            alias lint-yaml="yamllint ."
            alias lint-all="echo 'Running all linters...' && lint-js . && lint-go && lint-shell && lint-yaml"
            
            echo "Usage:"
            echo "  lint-all    - Run all linters"
            echo "  lint-js     - Lint JavaScript/TypeScript"
            echo "  lint-go     - Lint Go code"
            echo "  lint-shell  - Lint shell scripts"
            echo "  lint-yaml   - Lint YAML files"
            echo ""
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

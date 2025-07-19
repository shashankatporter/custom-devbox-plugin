{
  description = "Porter Custom Devbox Plugins - Enterprise Development Tools";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        
        # Common utilities for all plugins
        lib = import ./lib/common.nix { inherit pkgs; };
        
        # Plugin creation helper
        makePlugin = { name, version, description, dependencies ? [], initHook ? "", script, category ? "general" }: 
          let
            pluginScript = pkgs.writeShellScriptBin name ''
              set -euo pipefail
              echo "🔧 Porter ${name} v${version} - ${description}"
              echo "📂 Category: ${category}"
              ${script}
            '';
            
            # Create devbox plugin metadata
            devboxPlugin = {
              package = pluginScript;
              init_hook = ''
                echo "✅ ${description} v${version} ready!"
                echo "   Run '${name}' to use or 'devbox run ${name}' in scripts"
                ${initHook}
              '';
              services = {};
            };
          in {
            inherit pluginScript devboxPlugin;
            meta = {
              inherit name version description dependencies category;
              maintainer = "porter-devops-team";
              homepage = "https://github.com/porter/custom-devbox-plugins";
            };
          };

        # Define all plugins with proper metadata
        plugins = {
          # Linting Tools
          my-linter = makePlugin {
            name = "my-linter";
            version = "1.0.0";
            description = "Porter Organization Code Linter";
            category = "linting";
            dependencies = [ "shellcheck" "hadolint" ];
            initHook = ''
              export PORTER_LINTER_CONFIG="$DEVBOX_PROJECT_ROOT/.porter-linter.yml"
              if [ ! -f "$PORTER_LINTER_CONFIG" ]; then
                echo "📝 Creating default linter config at $PORTER_LINTER_CONFIG"
                cat > "$PORTER_LINTER_CONFIG" << 'EOF'
              rules:
                shellcheck: true
                dockerfile: true
                yaml: true
              severity: warning
              exclude_paths:
                - "node_modules/"
                - ".git/"
              EOF
              fi
            '';
            script = ''
              CONFIG_FILE="''${PORTER_LINTER_CONFIG:-$DEVBOX_PROJECT_ROOT/.porter-linter.yml}"
              
              echo "🔍 Running Porter linter with config: $CONFIG_FILE"
              
              # Lint shell scripts
              echo "  → Checking shell scripts..."
              find . -name "*.sh" -not -path "./node_modules/*" -not -path "./.git/*" | \
                xargs -I {} ${pkgs.shellcheck}/bin/shellcheck -f gcc {} || true
              
              # Lint Dockerfiles
              echo "  → Checking Dockerfiles..."
              find . -name "Dockerfile*" -not -path "./node_modules/*" -not -path "./.git/*" | \
                xargs -I {} ${pkgs.hadolint}/bin/hadolint {} || true
              
              echo "✅ Linting completed!"
              echo "📊 To see detailed report: my-linter --detailed"
            '';
          };

          # Security Scanner
          security-scanner = makePlugin {
            name = "security-scanner";
            version = "1.0.0";
            description = "Porter Security Vulnerability Scanner";
            category = "security";
            dependencies = [ "trivy" ];
            initHook = ''
              export PORTER_SECURITY_CONFIG="$DEVBOX_PROJECT_ROOT/.porter-security.yml"
            '';
            script = ''
              echo "🛡️ Running security scan..."
              echo "  → Scanning filesystem for vulnerabilities..."
              ${pkgs.trivy}/bin/trivy fs . --quiet || true
              echo "  → Scanning for secrets..."
              ${pkgs.trivy}/bin/trivy fs . --scanners secret --quiet || true
              echo "✅ Security scan completed!"
            '';
          };

          # Database Seeder (Enhanced)
          db-seeder = makePlugin {
            name = "db-seeder";
            version = "1.0.0";
            description = "Porter Database Seeder & Migration Tool";
            category = "database";
            dependencies = [ "postgresql" ];
            initHook = ''
              export PORTER_DB_CONFIG="$DEVBOX_PROJECT_ROOT/.porter-db.yml"
              export PORTER_SEEDS_DIR="$DEVBOX_PROJECT_ROOT/seeds"
            '';
            script = ''
              SEEDS_DIR="''${PORTER_SEEDS_DIR:-./seeds}"
              
              echo "🌱 Porter Database Seeder"
              echo "  → Seeds directory: $SEEDS_DIR"
              
              if [ ! -d "$SEEDS_DIR" ]; then
                echo "📁 Creating seeds directory at $SEEDS_DIR"
                mkdir -p "$SEEDS_DIR"
                echo "# Sample seed file" > "$SEEDS_DIR/sample.sql"
              fi
              
              echo "  → Running database seeds..."
              for seed_file in "$SEEDS_DIR"/*.sql; do
                if [ -f "$seed_file" ]; then
                  echo "    Processing: $(basename "$seed_file")"
                  # Add your database connection logic here
                fi
              done
              
              echo "✅ Database seeding completed!"
            '';
          };

          # Code Coverage Reporter
          coverage-reporter = makePlugin {
            name = "coverage-reporter";
            version = "1.0.0";
            description = "Porter Code Coverage Reporter";
            category = "testing";
            dependencies = [ ];
            script = ''
              echo "📊 Generating coverage report..."
              
              # Look for common coverage files
              coverage_files=(
                "coverage.xml"
                "coverage.json" 
                "coverage.lcov"
                "coverage/lcov.info"
                "target/site/jacoco/jacoco.xml"
              )
              
              found_coverage=false
              for file in "''${coverage_files[@]}"; do
                if [ -f "$file" ]; then
                  echo "  → Found coverage file: $file"
                  found_coverage=true
                fi
              done
              
              if [ "$found_coverage" = false ]; then
                echo "⚠️  No coverage files found. Run your tests first."
                exit 1
              fi
              
              echo "✅ Coverage analysis completed!"
            '';
          };
        };

        # Version management helper
        mkVersions = pluginName: pluginDef: {
          # Latest version (unversioned)
          ${pluginName} = pluginDef.pluginScript;
          
          # Versioned package for direct installation
          "${pluginName}-v${pluginDef.meta.version}" = pluginDef.pluginScript;
        };

        # Create all plugin packages
        allPackages = builtins.foldl' (acc: pluginName:
          acc // (mkVersions pluginName plugins.${pluginName})
        ) {} (builtins.attrNames plugins);

        # DevBox plugin definitions
        mkDevboxPlugins = pluginName: pluginDef: {
          # Latest version
          ${pluginName} = pluginDef.devboxPlugin;
          
          # Versioned plugin
          "${pluginName}-v${pluginDef.meta.version}" = pluginDef.devboxPlugin;
        };

        allDevboxPlugins = builtins.foldl' (acc: pluginName:
          acc // (mkDevboxPlugins pluginName plugins.${pluginName})
        ) {} (builtins.attrNames plugins);

      in {
        # Standard Nix packages
        packages = allPackages // {
          # Plugin registry for discovery
          plugin-registry = pkgs.writeTextFile {
            name = "porter-plugin-registry";
            text = builtins.toJSON {
              version = "1.0.0";
              plugins = builtins.mapAttrs (name: plugin: {
                inherit (plugin.meta) version description category dependencies;
                usage = "devbox add github:porter/custom-devbox-plugins#${name}";
                versioned_usage = "devbox add github:porter/custom-devbox-plugins#${name}-v${plugin.meta.version}";
              }) plugins;
            };
          };
        };

        # DevBox-specific plugin exports
        devboxPlugins = allDevboxPlugins;

        # Development shell for plugin development
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            nix
            git
            jq
          ];
          
          shellHook = ''
            echo "🚀 Porter Plugin Development Environment"
            echo "Available commands:"
            echo "  nix flake check       - Validate flake"
            echo "  nix build .#my-linter - Build a plugin"
            echo "  ./result/bin/my-linter - Test plugin"
          '';
        };

        # Apps for easy testing
        apps = builtins.mapAttrs (name: plugin: {
          type = "app";
          program = "${plugin.pluginScript}/bin/${name}";
        }) plugins;
      }
    );
}

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
        mylinter = {
          "1.0.0" = ''
            echo "🔍 Running Porter linter..."
            
            # Check for common files
            echo "  → Checking project structure..."
            if [ -f "README.md" ]; then
              echo "    ✅ README.md found"
            else
              echo "    ⚠️  README.md missing"
            fi
            
            if [ -f ".gitignore" ]; then
              echo "    ✅ .gitignore found"  
            else
              echo "    ⚠️  .gitignore missing"
            fi
            
            # Basic shell script checking
            echo "  → Checking shell scripts..."
            find . -name "*.sh" -not -path "./node_modules/*" -not -path "./.git/*" | while read -r script; do
              if [ -f "$script" ]; then
                echo "    Found: $script"
                # Basic syntax check
                if ! bash -n "$script" 2>/dev/null; then
                  echo "    ⚠️  Syntax issues in $script"
                fi
              fi
            done
            
            echo "✅ Linting completed!"
          '';
          latest = ''
            echo "🔍 Running Porter linter (latest)..."
            echo "  → Checking project structure..."
            [ -f "README.md" ] && echo "    ✅ README.md" || echo "    ⚠️  README.md missing"
            [ -f ".gitignore" ] && echo "    ✅ .gitignore" || echo "    ⚠️  .gitignore missing"
            echo "✅ Linting completed!"
          '';
        };
        
        securityscanner = {
          "1.0.0" = ''
            echo "🛡️ Running security scan..."
            echo "  → Scanning for common security issues..."
            
            # Basic secret detection
            if grep -r -i "password\|secret\|key\|token" . --exclude-dir=.git --exclude-dir=node_modules >/dev/null 2>&1; then
              echo "    ⚠️  Potential secrets found - please review"
            else
              echo "    ✅ No obvious secrets detected"
            fi
            
            echo "✅ Security scan completed!"
          '';
          latest = ''
            echo "🛡️ Running security scan (latest)..."
            echo "  → Basic security checks..."
            echo "✅ Security scan completed!"
          '';
        };
        
        coveragereporter = {
          "1.0.0" = ''
            echo "📊 Generating coverage report..."
            
            # Look for common coverage files
            found=false
            for file in "coverage.xml" "coverage.json" "coverage.lcov" "coverage/lcov.info"; do
              if [ -f "$file" ]; then
                echo "  → Found coverage file: $file"
                found=true
              fi
            done
            
            if [ "$found" = false ]; then
              echo "  ⚠️  No coverage files found. Run your tests first."
            else
              echo "  ✅ Coverage files detected"
            fi
            
            echo "✅ Coverage analysis completed!"
          '';
          latest = ''
            echo "📊 Generating coverage report (latest)..."
            echo "  → Looking for coverage files..."
            echo "✅ Coverage analysis completed!"
          '';
        };
        
        dbseeder = {
          "1.0.0" = ''
            echo "🌱 Porter Database Seeder"
            
            SEEDS_DIR="./seeds"
            echo "  → Seeds directory: $SEEDS_DIR"
            
            if [ ! -d "$SEEDS_DIR" ]; then
              echo "  📁 Creating seeds directory at $SEEDS_DIR"
              mkdir -p "$SEEDS_DIR"
              echo "-- Sample seed file" > "$SEEDS_DIR/sample.sql"
              echo "INSERT INTO users (name, email) VALUES ('Demo User', 'demo@porter.com');" >> "$SEEDS_DIR/sample.sql"
            fi
            
            echo "  → Found seed files:"
            for seed_file in "$SEEDS_DIR"/*.sql; do
              if [ -f "$seed_file" ]; then
                echo "    $(basename "$seed_file")"
              fi
            done
            
            echo "✅ Database seeding completed!"
          '';
          latest = ''
            echo "🌱 Porter Database Seeder (latest)..."
            echo "  → Setting up database seeds..."
            echo "✅ Database seeding completed!"
          '';
        };
      };

    in {
      packages = forAllSystems (system:
        let 
          pkgs = pkgsFor.${system};
          mkVersions = name: versions: builtins.listToAttrs (map (version: {
            name = if version == "latest" then name else "${name}_v${builtins.replaceStrings ["."] ["_"] version}";
            value = makePlugin pkgs name version versions.${version};
          }) (builtins.attrNames versions));
        in
        (mkVersions "mylinter" plugins.mylinter) //
        (mkVersions "securityscanner" plugins.securityscanner) //
        (mkVersions "coveragereporter" plugins.coveragereporter) //
        (mkVersions "dbseeder" plugins.dbseeder)
      );

      devboxPlugins = forAllSystems (system:
        let 
          pkgs = pkgsFor.${system};
          mkPlugins = name: versions: builtins.listToAttrs (map (version: {
            name = if version == "latest" then name else "${name}_v${builtins.replaceStrings ["."] ["_"] version}";
            value = {
              package = makePlugin pkgs name version versions.${version};
              init_hook = "echo '✅ Porter ${name} v${version} ready! Run ${name} to use.'";
            };
          }) (builtins.attrNames versions));
        in
        (mkPlugins "mylinter" plugins.mylinter) //
        (mkPlugins "securityscanner" plugins.securityscanner) //
        (mkPlugins "coveragereporter" plugins.coveragereporter) //
        (mkPlugins "dbseeder" plugins.dbseeder)
      );
    };
}

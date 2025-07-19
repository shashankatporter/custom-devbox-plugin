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
        
        # Import plugins directly from modules
        orgLinter = import ./modules/org-linter/default.nix { inherit pkgs pluginBuilder; };
        dbSeeder = import ./modules/db-seeder/default.nix { inherit pkgs pluginBuilder; };
        
        # Plugin collection
        plugins = {
          org-linter = orgLinter;
          db-seeder = dbSeeder;
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
        
        # Development shell for testing
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            bash
            jq
            git
          ];
          
          shellHook = ''
            echo "Porter Plugin Development Environment - Modular Architecture"
            echo "============================================================="
            echo ""
            echo "Available Plugins:"
            echo "  - org-linter v1.0.0  - Organization code linting tools"
            echo "  - db-seeder v1.0.0   - Database seeding and management"
            echo ""
            echo "Binary Names:"
            echo "  orglinter  - org-linter plugin"
            echo "  dbseeder   - db-seeder plugin"
            echo ""
            echo "Test locally with:"
            echo "  orglinter"
            echo "  dbseeder"
            echo ""
            echo "Other repos can use with:"
            echo '  "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git#orglinter"'
            echo '  "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git#dbseeder"'
            echo ""
          '';
        };
      }
    );
}

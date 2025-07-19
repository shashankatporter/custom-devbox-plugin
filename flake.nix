{
  description = "Porter Organization's Private Devbox Plugin Registry";

  # Define the inputs for our flake, primarily the Nix Packages collection.
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  # Define the outputs of our flake.
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        # Import plugins directly (avoiding builtins.readDir for Git compatibility)
        orgLinterPlugin = import ./plugins/org-linter/plugin.nix { inherit pkgs; };
        dbSeederPlugin = import ./plugins/db-seeder/plugin.nix { inherit pkgs; };

        # Plugin collection
        plugins = {
          org-linter = orgLinterPlugin;
          db-seeder = dbSeederPlugin;
        };

      in
      {
        # This is the special output that Devbox looks for.
        devboxPlugins = plugins;

        # Provide packages output for direct installation
        packages = {
          org-linter = orgLinterPlugin.package;
          db-seeder = dbSeederPlugin.package;
        };

        # Development shell for testing
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            bash
            jq
            git
          ];
          
          shellHook = ''
            echo "Porter Plugin Registry - Fixed SSH Architecture"
            echo "==============================================="
            echo ""
            echo "Available Plugins:"
            echo "  - org-linter"
            echo "  - db-seeder"
            echo ""
            echo "Usage in other repos:"
            echo '  "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git#org-linter"'
            echo '  "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git#db-seeder"'
            echo ""
          '';
        };

        # Default package for plugin listing
        defaultPackage = pkgs.writeShellScriptBin "list-plugins" ''
          echo "Available Porter organization plugins:"
          echo " - org-linter"
          echo " - db-seeder"
        '';
      }
    );

      # You can also add a "defaultPackage" for convenience,
      # for example, to provide a CLI that lists all available plugins.
      defaultPackage = forAllSystems (system:
        let pkgs = import nixpkgs { inherit system; };
        in pkgs.writeShellScriptBin "list-plugins" ''
          echo "Available Porter organization plugins:"
          ${nixpkgs.lib.concatStringsSep "\n" (map (name: "echo \" - ${name}\"") (builtins.attrNames pluginModules))}
        ''
      );

      # Development shell for testing
      devShells = forAllSystems (system: {
        default = let 
          pkgs = import nixpkgs { inherit system; };
        in pkgs.mkShell {
          buildInputs = with pkgs; [
            bash
            jq
            git
          ];
          
          shellHook = ''
            echo "Porter Plugin Registry - Clean Architecture"
            echo "==========================================="
            echo ""
            echo "Available Plugins:"
            ${nixpkgs.lib.concatStringsSep "\n" (map (name: "echo \"  - ${name}\"") (builtins.attrNames pluginModules))}
            echo ""
            echo "Usage in other repos:"
            echo '  "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git#org-linter"'
            echo '  "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git#db-seeder"'
            echo ""
          '';
        };
      });
    };
}

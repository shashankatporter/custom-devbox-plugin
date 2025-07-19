{
  description = "Porter Organization's Private Devbox Plugin Registry";

  # Define the inputs for our flake, primarily the Nix Packages collection.
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  # Define the outputs of our flake.
  outputs = { self, nixpkgs }:
    let
      # We define a set of supported systems to build for.
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];

      # Helper function to generate outputs for each system.
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # This is the magic part for combining modules.
      # It scans the `./plugins` directory and imports any `plugin.nix` file it finds.
      # The result is a single attribute set, e.g., { org-linter = { ... }; db-seeder = { ... }; }
      pluginModules = builtins.listToAttrs (
        map (pluginName: {
          name = pluginName;
          value = import ./plugins/${pluginName}/plugin.nix;
        }) (builtins.attrNames (builtins.readDir ./plugins))
      );

    in
    {
      # This is the special output that Devbox looks for.
      # It exposes all the combined plugin modules.
      devboxPlugins = forAllSystems (system:
        let
          # Pass pkgs to each plugin definition.
          # This allows each plugin.nix file to access Nix packages.
          pkgs = import nixpkgs { inherit system; };
        in
          # The `mapAttrs` function iterates through our combined `pluginModules`
          # and passes `pkgs` to each one, which evaluates it.
          nixpkgs.lib.mapAttrs (pluginName: pluginDef: pluginDef { inherit pkgs; }) pluginModules
      );

      # Provide packages output for direct installation
      packages = forAllSystems (system:
        let 
          pkgs = import nixpkgs { inherit system; };
          plugins = nixpkgs.lib.mapAttrs (pluginName: pluginDef: pluginDef { inherit pkgs; }) pluginModules;
        in
          nixpkgs.lib.mapAttrs (name: plugin: plugin.package) plugins
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

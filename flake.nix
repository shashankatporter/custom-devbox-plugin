# flake.nix
{
  description = "Porter Custom Devbox Plugins - Easy to use development tools";

  # Define the inputs for our flake, primarily Nix Packages collection.
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
      
      # Generate packages for each supported system.
      pkgsFor = forAllSystems (system: import nixpkgs { inherit system; });

      # Version information
      version = "1.0.0";
    in
    {
      # Expose packages that can be installed directly
      packages = forAllSystems (system:
        let pkgs = pkgsFor.${system};
        in
        {
          # Plugin 1: A simple linter
          org-linter = pkgs.writeShellScriptBin "org-linter" ''
            #!/bin/sh
            echo "🔍 Porter Org Linter v${version}"
            echo "Linting your project with the official Porter org linter..."
            # In a real scenario, you'd run your linter here.
            echo "✅ Linting complete!"
          '';

          # Plugin 2: A database seeder tool
          db-seeder = pkgs.writeShellScriptBin "db-seeder" ''
            #!/bin/sh
            echo "🌱 Porter DB Seeder v${version}"
            echo "Seeding the development database..."
            # Real logic to connect and seed a DB would go here.
            echo "✅ Database seeded!"
          '';

          # Plugin manager for easy installation
          porter-plugin-manager = pkgs.writeShellScriptBin "porter-plugin-manager" ''
            #!/bin/sh
            exec ${pkgs.bash}/bin/bash ${./porter-devbox-plugin-manager.sh} "$@"
          '';
        }
      );

      # This is the special output that Devbox looks for.
      devboxPlugins = forAllSystems (system:
        let 
          pkgs = pkgsFor.${system};
          packages = self.packages.${system};
        in
        {
          # Plugin 1: A simple linter with an init_hook
          org-linter = {
            # This is the package that `devbox add` will install.
            package = packages.org-linter;

            # This is a Devbox plugin hook. It runs when you enter `devbox shell`.
            init_hook = ''
              echo "✅ Porter Org Linter v${version} plugin is active."
              echo "Run 'org-linter' to lint your project."
            '';
          };

          # Plugin 2: A database seeder tool
          db-seeder = {
            package = packages.db-seeder;

            # You can add other metadata or hooks here if needed.
            init_hook = ''
              echo "🌱 Porter DB Seeder v${version} tool is available."
              echo "Run 'db-seeder' to populate your database."
            '';
          };
        }
      );

      # Add some metadata
      meta = {
        inherit version;
        description = "Porter Custom Devbox Plugins";
        homepage = "https://github.com/shashankatporter/custom-devbox-plugin";
        license = "MIT";
      };
    };
}
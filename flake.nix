# flake.nix
{
  description = "Single place to maintain custom plugins for Porter.";

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

    in
    {
      # This is the special output that Devbox looks for.
      devboxPlugins = forAllSystems (system:
        let pkgs = pkgsFor.${system};
        in
        {
          # Plugin 1: A simple linter with an init_hook
          org-linter = {
            # This is the package that `devbox add` will install.
            # Here we are just creating a dummy script.
            package = pkgs.writeShellScriptBin "org-linter" ''
              #!/bin/sh
              echo "Linting your project with the official org linter..."
              # In a real scenario, you'd run your linter here.
              echo "Linting complete!"
            '';

            # This is a Devbox plugin hook. It runs when you enter `devbox shell`.
            init_hook = ''
              echo "✅ Org Linter plugin is active."
            '';
          };

          # Plugin 2: A database seeder tool
          db-seeder = {
            package = pkgs.writeShellScriptBin "db-seeder" ''
              #!/bin/sh
              echo "Seeding the development database..."
              # Real logic to connect and seed a DB would go here.
              echo "Database seeded!"
            '';

            # You can add other metadata or hooks here if needed.
            init_hook = ''
              echo "🌱 DB Seeder tool is available. Run 'db-seeder' to populate your database."
            '';
          };
        }
      );
    };
}
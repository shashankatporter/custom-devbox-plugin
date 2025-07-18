# simple-flake.nix
{
  description = "Porter Devbox Plugins - Simple and Clean";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      pkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in
    {
      packages = forAllSystems (system:
        let pkgs = pkgsFor.${system};
        in
        {
          org-linter = pkgs.writeShellScriptBin "org-linter" ''
            #!/bin/sh
            echo "🔍 Porter Org Linter"
            echo "Checking project structure..."
            
            # Check for required files
            [ ! -f "README.md" ] && echo "⚠️  Missing README.md"
            [ ! -f ".gitignore" ] && echo "⚠️  Missing .gitignore"
            
            echo "✅ Linting complete!"
          '';

          db-seeder = pkgs.writeShellScriptBin "db-seeder" ''
            #!/bin/sh
            echo "🌱 Porter DB Seeder"
            echo "Seeding development database..."
            echo "  • Users: 10 records"
            echo "  • Products: 50 records"
            echo "✅ Seeding complete!"
          '';
        }
      );

      devboxPlugins = forAllSystems (system:
        let packages = self.packages.${system};
        in
        {
          org-linter = {
            package = packages.org-linter;
            init_hook = ''
              echo "✅ Porter Org Linter ready. Run 'org-linter' to check your code."
            '';
          };

          db-seeder = {
            package = packages.db-seeder;
            init_hook = ''
              echo "🌱 Porter DB Seeder ready. Run 'db-seeder' to seed your database."
            '';
          };
        }
      );
    };
}

{
  description = "Porter plugin collection for Local Development";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }:
    let
      system = builtins.currentSystem;
      pkgs   = import nixpkgs { inherit system; };
      # bundle the bash script together with its runtime dependencies
      lintApp = pkgs.writeShellApplication {
        name          = "linter";
        runtimeInputs = [
          pkgs.shellcheck
          # pkgs.python3  (uncomment if your script uses Python)
          # pkgs.nodejs   (if your script uses Node.js)
          # ...any others you use inside the script
        ];
        text          = builtins.readFile ./scripts/linter.sh;
      };
    in {
      packages.${system}.my-lint = lintApp;
      apps.${system}.my-lint = {
        type = "app";
        program = "${lintApp}/bin/linter";
      };

      # For backward compatibility, you can add 'default' if you want
      # defaultPackage = myLintApp;
      # defaultApp = {
      #   type = "app";
      #   program = "${myLintApp}/bin/my-lint";
      # };
    };
}

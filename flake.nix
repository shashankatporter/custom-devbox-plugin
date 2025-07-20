{
  description = "My Plugin-Like Devbox Flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
  };
  outputs = { self, nixpkgs }: 
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        # Use overlays here if needed
      };
    in {
      devShells.${system}.default = pkgs.mkShell {
        # Packages like Devbox plugins would add
        packages = [ pkgs.nodejs pkgs.mongodb ];
        # Environment variables
        shellHook = ''
          export MY_PLUGIN_VAR=1
          # Run custom lifecycle scripts, copy config, etc.
          source ./scripts/my-hook.sh
        '';
        # Can create/copy files if desired (using hooks)
      };
    };
}

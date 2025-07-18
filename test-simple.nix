{
  description = "Simple test";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs = { self, nixpkgs }: {
    packages.x86_64-darwin = {
      test = nixpkgs.legacyPackages.x86_64-darwin.writeShellScriptBin "test" "echo hello";
    };
  };
}

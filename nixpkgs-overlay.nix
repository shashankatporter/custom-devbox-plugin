# nixpkgs-overlay.nix - Overlay to add Porter plugins to nixpkgs
final: prev: {
  porter = {
    # Organization linter
    org-linter = final.callPackage ./packages/org-linter.nix { };
    
    # Database seeder
    db-seeder = final.callPackage ./packages/db-seeder.nix { };
  };
}

# lib/default.nix
# Main entry point for the Porter plugin library
{ lib, pkgs }:

{
  # Import and re-export all library functions
  inherit (import ./plugin-builder.nix { inherit lib pkgs; })
    buildPorterPlugin
    formatVersion
    createPluginOutputs;
    
  inherit (import ./version-manager.nix { inherit lib; })
    isValidVersion
    compareVersions
    getLatestVersion;
    
  inherit (import ./types.nix { inherit lib; })
    pluginMetadata
    versionConfig
    pluginModule;
}

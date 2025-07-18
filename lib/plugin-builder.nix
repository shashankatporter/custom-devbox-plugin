# Generic Plugin Builder Library
# This provides a consistent interface for building Porter plugins

{ lib, pkgs }:

let
  # Helper function to format version strings for attribute names
  formatVersion = version: builtins.replaceStrings ["."] ["-"] version;
  
  # Create outputs for both dot and dash versions
  createPluginOutputs = plugin: version: {
    # Dot version (quoted attribute)
    "\"${version}\"" = plugin;
    # Dash version (unquoted attribute)  
    "${formatVersion version}" = plugin;
  };

  # Generic plugin builder that all plugins can use
  buildPorterPlugin = { metadata, versions }:
    let
      name = metadata.name;
      
      # Build individual version derivations
      versionDerivations = builtins.mapAttrs (version: versionConfig:
        let
          packages = versionConfig.packages or [];
          shellInit = versionConfig.shellInit or "";
        in
        pkgs.writeShellScriptBin name ''
          echo "🔧 Porter ${name} v${version}"
          ${shellInit}
        ''
      ) versions;
      
    in {
      inherit metadata versions;
      derivations = versionDerivations;
    };

in {
  inherit buildPorterPlugin formatVersion createPluginOutputs;
}

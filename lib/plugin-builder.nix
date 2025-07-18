# Generic Plugin Builder Library
# This provides a consistent interface for building Porter plugins

{ pkgs, lib, stdenv }:

let
  # Generic plugin builder that all plugins can use
  buildPorterPlugin = {
    name,
    version,
    description ? "Porter plugin for ${name}",
    script,
    dependencies ? [],
    env ? {},
    initHook ? "",
    ...
  }:
    pkgs.writeShellScriptBin name ''
      # Porter Plugin: ${name} v${version}
      # Description: ${description}
      
      # Set environment variables
      ${lib.concatStringsSep "\n" (lib.mapAttrsToList (k: v: "export ${k}=${lib.escapeShellArg v}") env)}
      
      # Plugin header
      echo "🔧 Porter ${name} v${version}"
      
      # Run initialization hook if provided
      ${if initHook != "" then initHook else ""}
      
      # Main plugin script
      ${script}
    '';

  # Version formatter for attribute names
  formatVersion = version: builtins.replaceStrings ["."] ["-"] version;

  # Create versioned plugin set
  createVersionedPlugin = name: versions: 
    let
      makeVersionAttribute = version: script: {
        name = if version == "latest" then name else "${name}-v${formatVersion version}";
        value = buildPorterPlugin {
          inherit name version;
          script = script;
        };
      };
    in
    builtins.listToAttrs (lib.mapAttrsToList makeVersionAttribute versions);

  # Create both packages and devboxPlugins outputs
  createPluginOutputs = name: versions:
    let
      packages = createVersionedPlugin name versions;
      devboxPlugins = builtins.mapAttrs (attrName: pkg: {
        package = pkg;
        init_hook = "echo '✅ Porter ${name} ready! Run ${attrName} to use.'";
      }) packages;
    in {
      inherit packages devboxPlugins;
    };

in {
  inherit buildPorterPlugin formatVersion createVersionedPlugin createPluginOutputs;
}

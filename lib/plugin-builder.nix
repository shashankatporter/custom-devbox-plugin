{ pkgs }:

rec {
  # Core function to build Porter organization plugins
  buildPorterPlugin = {
    name,
    version,
    scriptPath,
    description ? "",
    dependencies ? [],
    commands ? {}
  }: 
  let
    # Create the main plugin script
    pluginScript = pkgs.writeShellScriptBin name ''
      echo "🚀 ${name} v${version}"
      echo "📝 ${description}"
      echo ""
      
      # Source the actual plugin implementation
      source "${scriptPath}"
    '';
    
    # Create additional command binaries if specified
    commandBinaries = pkgs.lib.mapAttrsToList (cmdName: cmdScript) commands;
    
    allBinaries = [ pluginScript ] ++ commandBinaries;
  in
  {
    type = "app";
    program = "${pluginScript}/bin/${name}";
    meta = {
      inherit name version description;
      binaries = map (bin: "${bin}/bin/*") allBinaries;
    };
  };

  # Utility to create plugin packages for the packages output
  makePluginPackage = plugin: pkgs.symlinkJoin {
    name = plugin.meta.name;
    paths = plugin.meta.binaries;
  };

  # Version management utilities
  versionUtils = {
    # Convert semantic version to Nix-compatible attribute name
    toAttrName = version: builtins.replaceStrings ["."] ["-"] version;
    
    # Extract major.minor.patch from version string
    parseVersion = version: 
      let
        cleaned = builtins.replaceStrings ["v"] [""] version;
        parts = pkgs.lib.splitString "." cleaned;
      in {
        major = builtins.elemAt parts 0;
        minor = if builtins.length parts > 1 then builtins.elemAt parts 1 else "0";
        patch = if builtins.length parts > 2 then builtins.elemAt parts 2 else "0";
      };
  };
}

# Type Definitions for Porter Plugins
{ lib }:

let
  # Plugin metadata type
  pluginMetadata = lib.types.submodule {
    options = {
      name = lib.mkOption {
        type = lib.types.str;
        description = "Plugin name";
      };
      
      description = lib.mkOption {
        type = lib.types.str;
        description = "Plugin description";
      };
      
      homepage = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Plugin homepage URL";
      };
      
      maintainers = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "List of plugin maintainers";
      };
      
      category = lib.mkOption {
        type = lib.types.str;
        default = "development";
        description = "Plugin category";
      };
    };
  };

  # Version configuration type
  versionConfig = lib.types.submodule {
    options = {
      script = lib.mkOption {
        type = lib.types.str;
        description = "Shell script content for this version";
      };
      
      dependencies = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "List of package dependencies";
      };
      
      env = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = {};
        description = "Environment variables to set";
      };
      
      initHook = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Initialization hook script";
      };
    };
  };

  # Plugin module type
  pluginModule = lib.types.submodule {
    options = {
      metadata = lib.mkOption {
        type = pluginMetadata;
        description = "Plugin metadata";
      };
      
      versions = lib.mkOption {
        type = lib.types.attrsOf versionConfig;
        description = "Version configurations";
      };
      
      enabled = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether plugin is enabled";
      };
    };
  };

in {
  inherit pluginMetadata versionConfig pluginModule;
}

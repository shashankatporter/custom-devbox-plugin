# registry/index.nix
# Central registry for all Porter plugins
{ lib, ... }:

let
  # Import all plugin modules
  org-linter = import ../modules/org-linter;
  db-seeder = import ../modules/db-seeder;
  
  # Plugin registry with metadata
  registry = {
    plugins = {
      inherit org-linter db-seeder;
    };
    
    categories = {
      development = [ "org-linter" ];
      database = [ "db-seeder" ];
    };
    
    tags = {
      linting = [ "org-linter" ];
      "code-quality" = [ "org-linter" ];
      database = [ "db-seeder" ];
      seeding = [ "db-seeder" ];
      migration = [ "db-seeder" ];
      porter = [ "org-linter" "db-seeder" ];
      organization = [ "org-linter" ];
      development = [ "org-linter" "db-seeder" ];
    };
    
    # Plugin discovery functions
    getPluginsByCategory = category: 
      lib.filter (name: lib.hasAttr category registry.categories && lib.elem name registry.categories.${category}) 
                 (lib.attrNames registry.plugins);
    
    getPluginsByTag = tag:
      if lib.hasAttr tag registry.tags 
      then registry.tags.${tag}
      else [];
    
    getAllPlugins = lib.attrNames registry.plugins;
    
    getPluginMetadata = pluginName:
      if lib.hasAttr pluginName registry.plugins
      then registry.plugins.${pluginName}.metadata or {}
      else {};
  };

in registry

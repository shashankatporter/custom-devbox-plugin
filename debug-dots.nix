{
  description = "Test flake for debugging dots in attribute names";

  outputs = { self, nixpkgs ? import <nixpkgs> {} }: 
    let
      # Test different approaches to handle dots
      testVersions = {
        # Approach 1: Direct quoted attribute (what we know doesn't work well)
        "v1.0.0" = "test";
        
        # Approach 2: Using lib.strings.escapeNixString
        escaped = builtins.replaceStrings ["."] ["_DOT_"] "v1.0.0";
      };

      # Approach 3: Using different attribute creation method
      makeVersionAttrs = versions: 
        builtins.listToAttrs (map (version: {
          name = "plugin-${builtins.replaceStrings ["."] ["-"] version}";
          value = {
            originalVersion = version;
            package = "test-package-${version}";
          };
        }) versions);

      # Approach 4: Create a mapping function that preserves dots internally
      createVersionMapping = pluginName: versions:
        builtins.listToAttrs (map (version: {
          # Create safe attribute name but store original version
          name = "${pluginName}-${builtins.replaceStrings ["."] ["_"] version}";
          value = {
            version = version;  # Preserve original version with dots
            package = "package for ${version}";
          };
        }) versions);

    in {
      packages.x86_64-linux = 
        (makeVersionAttrs ["1.0.0" "1.1.0" "2.0.0"]) //
        (createVersionMapping "org-linter" ["1.0.0" "1.2.3"]) //
        {
          # Test if we can access via different methods
          test = testVersions;
        };
      
      # Test different access patterns
      testAccess = {
        # Can we create a function that maps back?
        getByVersion = version: 
          builtins.getAttr "org-linter-${builtins.replaceStrings ["."] ["_"] version}" 
          (createVersionMapping "org-linter" ["1.0.0" "1.2.3"]);
      };
    };
}

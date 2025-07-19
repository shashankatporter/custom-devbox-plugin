# Common utilities for Porter plugins
{ pkgs, ... }:

{
  # Generate plugin metadata
  mkPluginMeta = name: version: description: category: {
    inherit name version description category;
    maintainer = "porter-devops-team";
    homepage = "https://github.com/porter/custom-devbox-plugins";
    license = "proprietary";
  };

  # Common environment setup
  commonEnv = {
    PORTER_PLUGIN_VERSION = "1.0.0";
    PORTER_ORG = "porter";
    PORTER_CONFIG_DIR = "$DEVBOX_PROJECT_ROOT/.porter";
  };

  # Utility functions for plugins
  utils = {
    # Check if file exists
    fileExists = file: ''
      if [ -f "${file}" ]; then
        echo "✓ Found: ${file}"
        return 0
      else
        echo "✗ Missing: ${file}"
        return 1
      fi
    '';

    # Create directory if it doesn't exist
    ensureDir = dir: ''
      if [ ! -d "${dir}" ]; then
        echo "📁 Creating directory: ${dir}"
        mkdir -p "${dir}"
      fi
    '';

    # Parse YAML config (basic)
    parseYaml = file: ''
      if command -v ${pkgs.yq}/bin/yq >/dev/null 2>&1; then
        ${pkgs.yq}/bin/yq eval . "${file}"
      else
        echo "⚠️  yq not available, skipping YAML parsing"
        cat "${file}"
      fi
    '';

    # Standard error handling
    handleError = cmd: ''
      if ! ${cmd}; then
        echo "❌ Command failed: ${cmd}"
        exit 1
      fi
    '';

    # Progress indicator
    progress = msg: ''
      echo "⏳ ${msg}..."
    '';

    # Success indicator  
    success = msg: ''
      echo "✅ ${msg}"
    '';

    # Warning indicator
    warn = msg: ''
      echo "⚠️  ${msg}"
    '';
  };
}

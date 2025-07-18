#!/bin/bash
# scripts/add-plugin.sh
# Script to add a new plugin to the Porter plugin system

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Helper functions
log() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# Validate plugin name
validate_plugin_name() {
    local name="$1"
    if [[ ! "$name" =~ ^[a-z][a-z0-9-]*[a-z0-9]$ ]]; then
        error "Plugin name must be lowercase, start with a letter, and contain only letters, numbers, and hyphens"
    fi
}

# Validate semantic version
validate_version() {
    local version="$1"
    if [[ ! "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        error "Version must follow semantic versioning format (e.g., 1.0.0)"
    fi
}

# Create plugin directory structure
create_plugin_structure() {
    local plugin_name="$1"
    local plugin_dir="$PROJECT_ROOT/modules/$plugin_name"
    
    log "Creating plugin directory: $plugin_dir"
    mkdir -p "$plugin_dir"
    
    if [[ -f "$plugin_dir/default.nix" ]]; then
        warn "Plugin $plugin_name already exists. Skipping file creation."
        return 0
    fi
    
    return 1
}

# Generate plugin template
generate_plugin_template() {
    local plugin_name="$1"
    local description="$2"
    local category="$3"
    local version="$4"
    local packages="$5"
    local plugin_file="$PROJECT_ROOT/modules/$plugin_name/default.nix"
    
    log "Generating plugin template: $plugin_file"
    
    # Convert packages string to nix array format
    local packages_array=""
    IFS=',' read -ra PACKAGE_LIST <<< "$packages"
    for package in "${PACKAGE_LIST[@]}"; do
        package=$(echo "$package" | xargs) # trim whitespace
        packages_array="$packages_array        \"$package\"\n"
    done
    
    cat > "$plugin_file" << EOF
# modules/$plugin_name/default.nix
{ lib, buildPorterPlugin, ... }:

buildPorterPlugin {
  metadata = {
    name = "$plugin_name";
    description = "$description";
    category = "$category";
    tags = [ "$category" "porter" ];
    maintainers = [ "porter-team" ];
    repository = "https://github.com/porter-dev/custom-devbox-plugin";
  };

  versions = {
    "$version" = {
      hash = "sha256-PLACEHOLDER"; # Will be updated during build
      packages = [
$(echo -e "$packages_array")      ];
      shellInit = ''
        echo "🚀 Porter $plugin_name v$version initialized"
        echo "Description: $description"
        
        # Add your custom shell initialization here
        # export CUSTOM_VAR="value"
        # alias custom-command="echo 'Hello from $plugin_name'"
        
        echo "Plugin $plugin_name is ready to use!"
      '';
    };
  };
}
EOF
    
    success "Created plugin template: $plugin_file"
}

# Update registry
update_registry() {
    local plugin_name="$1"
    local category="$2"
    local registry_file="$PROJECT_ROOT/registry/index.nix"
    
    log "Updating registry: $registry_file"
    
    # Backup registry
    cp "$registry_file" "$registry_file.bak"
    
    # Add plugin to registry (simple approach - manually edit for now)
    warn "Registry update requires manual editing of $registry_file"
    warn "Please add '$plugin_name' to the plugins and categories sections"
}

# Update main flake.nix
update_flake() {
    local plugin_name="$1"
    local flake_file="$PROJECT_ROOT/flake.nix"
    
    log "Plugin added successfully!"
    warn "You may need to update $flake_file to include the new plugin"
    warn "Run 'nix flake update' to refresh the lock file"
}

# Main function
main() {
    echo "🔧 Porter Plugin Generator"
    echo "=========================="
    
    # Interactive prompts
    read -p "Plugin name (lowercase, hyphen-separated): " plugin_name
    validate_plugin_name "$plugin_name"
    
    read -p "Description: " description
    if [[ -z "$description" ]]; then
        error "Description cannot be empty"
    fi
    
    echo "Available categories: development, database, testing, deployment, security, monitoring"
    read -p "Category: " category
    if [[ -z "$category" ]]; then
        category="development"
    fi
    
    read -p "Initial version (default: 1.0.0): " version
    if [[ -z "$version" ]]; then
        version="1.0.0"
    fi
    validate_version "$version"
    
    read -p "Packages (comma-separated): " packages
    if [[ -z "$packages" ]]; then
        packages="nodejs_20"
    fi
    
    echo
    log "Creating plugin with the following configuration:"
    echo "  Name: $plugin_name"
    echo "  Description: $description"
    echo "  Category: $category"
    echo "  Version: $version"
    echo "  Packages: $packages"
    echo
    
    read -p "Proceed? [y/N]: " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        error "Operation cancelled"
    fi
    
    # Create plugin
    if create_plugin_structure "$plugin_name"; then
        generate_plugin_template "$plugin_name" "$description" "$category" "$version" "$packages"
        update_registry "$plugin_name" "$category"
        update_flake "$plugin_name"
        
        success "Plugin '$plugin_name' created successfully!"
        echo
        echo "Next steps:"
        echo "1. Edit modules/$plugin_name/default.nix to customize your plugin"
        echo "2. Update registry/index.nix to include your plugin"
        echo "3. Test with: nix flake show"
        echo "4. Commit your changes"
    fi
}

# Run main function
main "$@"

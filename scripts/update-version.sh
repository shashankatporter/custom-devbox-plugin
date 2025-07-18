#!/bin/bash
# scripts/update-version.sh
# Script to update plugin versions in the Porter plugin system

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

# List available plugins
list_plugins() {
    log "Available plugins:"
    for plugin_dir in "$PROJECT_ROOT/modules"/*; do
        if [[ -d "$plugin_dir" ]]; then
            local plugin_name=$(basename "$plugin_dir")
            echo "  - $plugin_name"
        fi
    done
}

# Get current versions for a plugin
get_current_versions() {
    local plugin_name="$1"
    local plugin_file="$PROJECT_ROOT/modules/$plugin_name/default.nix"
    
    if [[ ! -f "$plugin_file" ]]; then
        error "Plugin $plugin_name not found"
    fi
    
    log "Current versions for $plugin_name:"
    grep -E '^\s*"[0-9]+\.[0-9]+\.[0-9]+"' "$plugin_file" | sed 's/.*"\([0-9.]*\)".*/  - \1/'
}

# Validate semantic version
validate_version() {
    local version="$1"
    if [[ ! "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        error "Version must follow semantic versioning format (e.g., 1.0.0)"
    fi
}

# Check if version already exists
version_exists() {
    local plugin_name="$1"
    local version="$2"
    local plugin_file="$PROJECT_ROOT/modules/$plugin_name/default.nix"
    
    grep -q "\"$version\"" "$plugin_file"
}

# Add new version to plugin
add_version() {
    local plugin_name="$1"
    local new_version="$2"
    local copy_from_version="$3"
    local plugin_file="$PROJECT_ROOT/modules/$plugin_name/default.nix"
    
    log "Adding version $new_version to $plugin_name"
    
    # Backup the file
    cp "$plugin_file" "$plugin_file.bak"
    
    # Find the last version block and extract its content
    local version_block=""
    local in_version=false
    local brace_count=0
    local line_number=0
    
    # Read the content of the version to copy
    while IFS= read -r line; do
        ((line_number++))
        if [[ "$line" =~ \"$copy_from_version\"[[:space:]]*= ]]; then
            in_version=true
            version_block="    \"$new_version\" = {"
            continue
        fi
        
        if [[ "$in_version" == true ]]; then
            # Count braces to know when the version block ends
            local open_braces=$(echo "$line" | grep -o '{' | wc -l)
            local close_braces=$(echo "$line" | grep -o '}' | wc -l)
            brace_count=$((brace_count + open_braces - close_braces))
            
            if [[ $brace_count -eq 0 && "$line" =~ }[[:space:]]*;[[:space:]]*$ ]]; then
                version_block="$version_block\n$line"
                break
            else
                version_block="$version_block\n$line"
            fi
        fi
    done < "$plugin_file"
    
    # Insert the new version block before the closing of versions
    local temp_file=$(mktemp)
    local versions_closing=false
    
    while IFS= read -r line; do
        if [[ "$line" =~ ^[[:space:]]*}[[:space:]]*;[[:space:]]*$ ]] && [[ "$versions_closing" == true ]]; then
            echo -e "$version_block" >> "$temp_file"
            echo "" >> "$temp_file"
            echo "$line" >> "$temp_file"
            versions_closing=false
        elif [[ "$line" =~ versions[[:space:]]*=[[:space:]]*{ ]]; then
            echo "$line" >> "$temp_file"
            versions_closing=true
        else
            echo "$line" >> "$temp_file"
        fi
    done < "$plugin_file"
    
    mv "$temp_file" "$plugin_file"
    success "Added version $new_version to $plugin_name"
}

# Remove version from plugin
remove_version() {
    local plugin_name="$1"
    local version="$2"
    local plugin_file="$PROJECT_ROOT/modules/$plugin_name/default.nix"
    
    log "Removing version $version from $plugin_name"
    
    # Backup the file
    cp "$plugin_file" "$plugin_file.bak"
    
    # Remove the version block
    local temp_file=$(mktemp)
    local in_version=false
    local brace_count=0
    
    while IFS= read -r line; do
        if [[ "$line" =~ \"$version\"[[:space:]]*= ]]; then
            in_version=true
            continue
        fi
        
        if [[ "$in_version" == true ]]; then
            local open_braces=$(echo "$line" | grep -o '{' | wc -l)
            local close_braces=$(echo "$line" | grep -o '}' | wc -l)
            brace_count=$((brace_count + open_braces - close_braces))
            
            if [[ $brace_count -eq 0 && "$line" =~ }[[:space:]]*;[[:space:]]*$ ]]; then
                in_version=false
                continue
            else
                continue
            fi
        fi
        
        echo "$line" >> "$temp_file"
    done < "$plugin_file"
    
    mv "$temp_file" "$plugin_file"
    success "Removed version $version from $plugin_name"
}

# Main function
main() {
    echo "🔄 Porter Plugin Version Manager"
    echo "================================"
    
    if [[ $# -eq 0 ]]; then
        echo "Usage: $0 <action> [options]"
        echo
        echo "Actions:"
        echo "  list                    List all available plugins"
        echo "  versions <plugin>       Show versions for a plugin"
        echo "  add <plugin> <version>  Add a new version to a plugin"
        echo "  remove <plugin> <ver>   Remove a version from a plugin"
        echo
        echo "Examples:"
        echo "  $0 list"
        echo "  $0 versions org-linter"
        echo "  $0 add org-linter 1.1.0"
        echo "  $0 remove org-linter 1.0.0"
        exit 1
    fi
    
    local action="$1"
    
    case "$action" in
        "list")
            list_plugins
            ;;
        "versions")
            if [[ $# -lt 2 ]]; then
                error "Plugin name required. Usage: $0 versions <plugin>"
            fi
            get_current_versions "$2"
            ;;
        "add")
            if [[ $# -lt 3 ]]; then
                error "Plugin name and version required. Usage: $0 add <plugin> <version>"
            fi
            local plugin_name="$2"
            local new_version="$3"
            
            validate_version "$new_version"
            
            if version_exists "$plugin_name" "$new_version"; then
                error "Version $new_version already exists for $plugin_name"
            fi
            
            # Ask which version to copy from
            echo "Available versions to copy from:"
            get_current_versions "$plugin_name"
            read -p "Copy from version (or press Enter for latest): " copy_from
            
            if [[ -z "$copy_from" ]]; then
                # Find the latest version
                copy_from=$(grep -E '^\s*"[0-9]+\.[0-9]+\.[0-9]+"' "$PROJECT_ROOT/modules/$plugin_name/default.nix" | sed 's/.*"\([0-9.]*\)".*/\1/' | sort -V | tail -1)
            fi
            
            add_version "$plugin_name" "$new_version" "$copy_from"
            ;;
        "remove")
            if [[ $# -lt 3 ]]; then
                error "Plugin name and version required. Usage: $0 remove <plugin> <version>"
            fi
            local plugin_name="$2"
            local version="$3"
            
            if ! version_exists "$plugin_name" "$version"; then
                error "Version $version does not exist for $plugin_name"
            fi
            
            read -p "Are you sure you want to remove version $version from $plugin_name? [y/N]: " confirm
            if [[ "$confirm" =~ ^[Yy]$ ]]; then
                remove_version "$plugin_name" "$version"
            else
                log "Operation cancelled"
            fi
            ;;
        *)
            error "Unknown action: $action"
            ;;
    esac
    
    log "Remember to run 'nix flake update' after making changes"
}

# Run main function
main "$@"

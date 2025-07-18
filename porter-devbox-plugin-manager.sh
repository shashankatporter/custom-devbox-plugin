#!/bin/bash
# porter-devbox-plugin-manager.sh - Easy way to add Porter plugins to devbox with version management

set -e

PLUGIN_REPO="git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git"
VERSION_FILE="https://raw.githubusercontent.com/shashankatporter/custom-devbox-plugin/main/plugin-versions.json"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

usage() {
    echo -e "${BLUE}Porter Devbox Plugin Manager v2.0${NC}"
    echo ""
    echo "Usage: $0 <command> [plugin-name] [version]"
    echo ""
    echo "Commands:"
    echo "  list                          List all available plugins"
    echo "  versions <plugin-name>        Show all versions of a plugin"
    echo "  add <plugin-name> [version]   Add a plugin (latest version if not specified)"
    echo "  remove <plugin-name>          Remove a plugin"
    echo "  info <plugin-name> [version]  Show information about a plugin version"
    echo "  update <plugin-name>          Update plugin to latest version"
    echo ""
    echo "Examples:"
    echo "  $0 add org-linter              # Install latest version"
    echo "  $0 add org-linter 1.1.0        # Install specific version"
    echo "  $0 versions org-linter          # Show all versions"
    echo "  $0 update org-linter            # Update to latest"
}

check_devbox() {
    if ! command -v devbox &> /dev/null; then
        echo -e "${RED}Error: devbox is not installed or not in PATH${NC}"
        exit 1
    fi
    
    if [ ! -f "devbox.json" ]; then
        echo -e "${RED}Error: No devbox.json found in current directory${NC}"
        echo "Please run this command from a devbox project directory or run 'devbox init' first"
        exit 1
    fi
}

fetch_version_info() {
    # In a real scenario, you'd fetch from the URL or have it locally
    # For now, we'll use a local approach
    if [ -f "plugin-versions.json" ]; then
        cat plugin-versions.json
    else
        # Fallback to embedded version info
        echo '{
  "plugins": {
    "org-linter": {
      "current_version": "1.2.0",
      "versions": {
        "1.0.0": {"description": "Initial release", "git_ref": "v1.0.0"},
        "1.1.0": {"description": "Added configuration support", "git_ref": "v1.1.0"},
        "1.2.0": {"description": "Multi-file support", "git_ref": "v1.2.0"}
      }
    },
    "db-seeder": {
      "current_version": "2.1.0",
      "versions": {
        "1.0.0": {"description": "Initial release", "git_ref": "v1.0.0"},
        "2.0.0": {"description": "Multi-database support", "git_ref": "v2.0.0"},
        "2.1.0": {"description": "MongoDB support", "git_ref": "v2.1.0"}
      }
    }
  }
}'
    fi
}

get_plugin_flake() {
    local plugin_name=$1
    local version=$2
    local git_ref=""
    
    if [ -n "$version" ]; then
        # Get git reference for specific version
        git_ref=$(fetch_version_info | jq -r ".plugins[\"$plugin_name\"].versions[\"$version\"].git_ref // empty")
        if [ -z "$git_ref" ]; then
            echo -e "${RED}Error: Version $version not found for plugin $plugin_name${NC}"
            return 1
        fi
        echo "${PLUGIN_REPO}?ref=${git_ref}#${plugin_name}"
    else
        # Use latest version (main branch)
        echo "${PLUGIN_REPO}#${plugin_name}"
    fi
}

list_plugins() {
    echo -e "${BLUE}Available Porter Devbox Plugins:${NC}"
    echo ""
    
    local info=$(fetch_version_info)
    echo "$info" | jq -r '.plugins | to_entries[] | "\(.key) (latest: \(.value.current_version))"' | while read -r line; do
        plugin=$(echo "$line" | cut -d' ' -f1)
        version=$(echo "$line" | cut -d' ' -f3 | tr -d ')')
        
        case $plugin in
            "org-linter")
                echo -e "${GREEN}$plugin${NC} ${CYAN}$version${NC}     Official Porter organization linter"
                ;;
            "db-seeder")
                echo -e "${GREEN}$plugin${NC} ${CYAN}$version${NC}      Database seeding tool for development"
                ;;
        esac
    done
    
    echo ""
    echo "Use '$0 versions <plugin-name>' to see all available versions"
    echo "Use '$0 info <plugin-name>' for detailed information"
}

show_versions() {
    local plugin_name=$1
    local info=$(fetch_version_info)
    
    echo -e "${BLUE}Available versions for $plugin_name:${NC}"
    echo ""
    
    echo "$info" | jq -r ".plugins[\"$plugin_name\"].versions // {} | to_entries[] | \"\(.key): \(.value.description)\"" | while read -r line; do
        version=$(echo "$line" | cut -d':' -f1)
        desc=$(echo "$line" | cut -d':' -f2-)
        echo -e "${GREEN}v$version${NC}$desc"
    done
    
    local current=$(echo "$info" | jq -r ".plugins[\"$plugin_name\"].current_version // \"unknown\"")
    echo ""
    echo -e "Latest version: ${CYAN}v$current${NC}"
}

add_plugin() {
    local plugin_name=$1
    local version=$2
    local flake_url
    
    if ! flake_url=$(get_plugin_flake "$plugin_name" "$version"); then
        exit 1
    fi
    
    if [ -n "$version" ]; then
        echo -e "${YELLOW}Adding plugin: $plugin_name v$version${NC}"
    else
        echo -e "${YELLOW}Adding plugin: $plugin_name (latest)${NC}"
    fi
    echo "Flake URL: $flake_url"
    
    if devbox add "$flake_url"; then
        echo -e "${GREEN}✅ Successfully added $plugin_name${NC}"
        echo ""
        echo "To use the plugin, run: devbox shell"
    else
        echo -e "${RED}❌ Failed to add $plugin_name${NC}"
        exit 1
    fi
}

remove_plugin() {
    local plugin_name=$1
    local flake_url
    
    # For removal, we don't need version-specific URL
    if ! flake_url=$(get_plugin_flake "$plugin_name"); then
        exit 1
    fi
    
    echo -e "${YELLOW}Removing plugin: $plugin_name${NC}"
    
    if devbox remove "$flake_url"; then
        echo -e "${GREEN}✅ Successfully removed $plugin_name${NC}"
    else
        echo -e "${RED}❌ Failed to remove $plugin_name${NC}"
        exit 1
    fi
}

show_plugin_info() {
    local plugin_name=$1
    local version=$2
    local info=$(fetch_version_info)
    
    if [ -n "$version" ]; then
        echo -e "${BLUE}$plugin_name v$version${NC}"
        echo ""
        
        local desc=$(echo "$info" | jq -r ".plugins[\"$plugin_name\"].versions[\"$version\"].description // \"No description available\"")
        local features=$(echo "$info" | jq -r ".plugins[\"$plugin_name\"].versions[\"$version\"].features[]? // empty")
        
        echo "Description: $desc"
        echo ""
        
        if [ -n "$features" ]; then
            echo "Features:"
            echo "$features" | while read -r feature; do
                echo "  • $feature"
            done
        fi
    else
        case $plugin_name in
            "org-linter")
                echo -e "${BLUE}Porter Org Linter${NC}"
                echo "Description: Official Porter organization linter for code standards"
                echo "Category: Linting"
                echo "Commands: org-linter"
                ;;
            "db-seeder")
                echo -e "${BLUE}Porter DB Seeder${NC}"
                echo "Description: Database seeding tool for Porter development environments"
                echo "Category: Database"
                echo "Commands: db-seeder"
                ;;
            *)
                echo -e "${RED}Error: Unknown plugin '$plugin_name'${NC}"
                echo "Run '$0 list' to see available plugins"
                exit 1
                ;;
        esac
        
        local current=$(echo "$info" | jq -r ".plugins[\"$plugin_name\"].current_version // \"unknown\"")
        echo ""
        echo -e "Latest version: ${CYAN}v$current${NC}"
        echo "Repository: https://github.com/shashankatporter/custom-devbox-plugin"
    fi
}

update_plugin() {
    local plugin_name=$1
    
    echo -e "${YELLOW}Updating $plugin_name to latest version...${NC}"
    
    # Remove current version and add latest
    remove_plugin "$plugin_name"
    add_plugin "$plugin_name"
}

# Main script logic
case "${1:-}" in
    "list")
        list_plugins
        ;;
    "versions")
        if [ -z "${2:-}" ]; then
            echo -e "${RED}Error: Please specify a plugin name${NC}"
            usage
            exit 1
        fi
        show_versions "$2"
        ;;
    "add")
        if [ -z "${2:-}" ]; then
            echo -e "${RED}Error: Please specify a plugin name${NC}"
            usage
            exit 1
        fi
        check_devbox
        add_plugin "$2" "$3"
        ;;
    "remove")
        if [ -z "${2:-}" ]; then
            echo -e "${RED}Error: Please specify a plugin name${NC}"
            usage
            exit 1
        fi
        check_devbox
        remove_plugin "$2"
        ;;
    "info")
        if [ -z "${2:-}" ]; then
            echo -e "${RED}Error: Please specify a plugin name${NC}"
            usage
            exit 1
        fi
        show_plugin_info "$2" "$3"
        ;;
    "update")
        if [ -z "${2:-}" ]; then
            echo -e "${RED}Error: Please specify a plugin name${NC}"
            usage
            exit 1
        fi
        check_devbox
        update_plugin "$2"
        ;;
    "help"|"-h"|"--help")
        usage
        ;;
    *)
        echo -e "${RED}Error: Unknown command '${1:-}'${NC}"
        echo ""
        usage
        exit 1
        ;;
esac

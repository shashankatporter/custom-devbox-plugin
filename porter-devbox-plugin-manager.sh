#!/bin/bash
# porter-devbox-plugin-manager.sh - Easy way to add Porter plugins to devbox

set -e

PLUGIN_REPO="git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git"
PLUGIN_REGISTRY_URL="https://raw.githubusercontent.com/shashankatporter/custom-devbox-plugin/main/plugin-registry.json"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

usage() {
    echo -e "${BLUE}Porter Devbox Plugin Manager${NC}"
    echo ""
    echo "Usage: $0 <command> [plugin-name]"
    echo ""
    echo "Commands:"
    echo "  list                    List all available plugins"
    echo "  add <plugin-name>       Add a plugin to your devbox project"
    echo "  remove <plugin-name>    Remove a plugin from your devbox project"
    echo "  info <plugin-name>      Show information about a plugin"
    echo ""
    echo "Available plugins:"
    echo "  porter-org-linter       Official Porter organization linter"
    echo "  porter-db-seeder        Database seeding tool"
    echo ""
    echo "Examples:"
    echo "  $0 add porter-org-linter"
    echo "  $0 list"
    echo "  $0 info porter-db-seeder"
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

get_plugin_flake() {
    local plugin_name=$1
    case $plugin_name in
        "porter-org-linter")
            echo "${PLUGIN_REPO}#org-linter"
            ;;
        "porter-db-seeder")
            echo "${PLUGIN_REPO}#db-seeder"
            ;;
        *)
            echo ""
            ;;
    esac
}

list_plugins() {
    echo -e "${BLUE}Available Porter Devbox Plugins:${NC}"
    echo ""
    echo -e "${GREEN}porter-org-linter${NC}      Official Porter organization linter"
    echo -e "${GREEN}porter-db-seeder${NC}       Database seeding tool for development"
    echo ""
    echo "Use '$0 info <plugin-name>' for more details"
}

add_plugin() {
    local plugin_name=$1
    local flake_url=$(get_plugin_flake "$plugin_name")
    
    if [ -z "$flake_url" ]; then
        echo -e "${RED}Error: Unknown plugin '$plugin_name'${NC}"
        echo "Run '$0 list' to see available plugins"
        exit 1
    fi
    
    echo -e "${YELLOW}Adding plugin: $plugin_name${NC}"
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
    local flake_url=$(get_plugin_flake "$plugin_name")
    
    if [ -z "$flake_url" ]; then
        echo -e "${RED}Error: Unknown plugin '$plugin_name'${NC}"
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
    
    case $plugin_name in
        "porter-org-linter")
            echo -e "${BLUE}Porter Org Linter${NC}"
            echo "Description: Official Porter organization linter for code standards"
            echo "Category: Linting"
            echo "Commands: org-linter"
            echo "Repository: https://github.com/shashankatporter/custom-devbox-plugin"
            ;;
        "porter-db-seeder")
            echo -e "${BLUE}Porter DB Seeder${NC}"
            echo "Description: Database seeding tool for Porter development environments"
            echo "Category: Database"
            echo "Commands: db-seeder"
            echo "Repository: https://github.com/shashankatporter/custom-devbox-plugin"
            ;;
        *)
            echo -e "${RED}Error: Unknown plugin '$plugin_name'${NC}"
            echo "Run '$0 list' to see available plugins"
            exit 1
            ;;
    esac
}

# Main script logic
case "${1:-}" in
    "list")
        list_plugins
        ;;
    "add")
        if [ -z "${2:-}" ]; then
            echo -e "${RED}Error: Please specify a plugin name${NC}"
            usage
            exit 1
        fi
        check_devbox
        add_plugin "$2"
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
        show_plugin_info "$2"
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

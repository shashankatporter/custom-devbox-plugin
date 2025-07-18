#!/bin/bash
# simple-plugin-manager.sh - Clean and simple Porter plugin manager

set -e

PLUGIN_REPO="git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git"

# Available plugins
declare -A PLUGINS=(
    ["org-linter"]="Official Porter organization linter"
    ["db-seeder"]="Database seeding tool for development"
)

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

usage() {
    echo -e "${BLUE}Porter Plugin Manager - Simple Version${NC}"
    echo ""
    echo "Usage: $0 <command> [plugin-name] [version]"
    echo ""
    echo "Commands:"
    echo "  list                          List available plugins"
    echo "  add <plugin> [version]        Add plugin (latest if no version)"
    echo "  remove <plugin>               Remove plugin"
    echo ""
    echo "Available plugins:"
    for plugin in "${!PLUGINS[@]}"; do
        echo "  $plugin - ${PLUGINS[$plugin]}"
    done
    echo ""
    echo "Examples:"
    echo "  $0 add org-linter             # Latest version"
    echo "  $0 add org-linter v1.2.0      # Specific version"
    echo "  $0 remove org-linter          # Remove plugin"
}

check_devbox() {
    if ! command -v devbox &> /dev/null; then
        echo -e "${RED}Error: devbox not found${NC}"
        exit 1
    fi
    
    if [ ! -f "devbox.json" ]; then
        echo -e "${RED}Error: No devbox.json found${NC}"
        echo "Run 'devbox init' first"
        exit 1
    fi
}

add_plugin() {
    local plugin=$1
    local version=$2
    
    if [[ ! " ${!PLUGINS[@]} " =~ " ${plugin} " ]]; then
        echo -e "${RED}Error: Unknown plugin '$plugin'${NC}"
        echo "Run '$0 list' to see available plugins"
        exit 1
    fi
    
    local repo_url="$PLUGIN_REPO"
    if [ -n "$version" ]; then
        repo_url="$PLUGIN_REPO?ref=$version"
        echo -e "${YELLOW}Adding $plugin $version${NC}"
    else
        echo -e "${YELLOW}Adding $plugin (latest)${NC}"
    fi
    
    if devbox add "$repo_url#$plugin"; then
        echo -e "${GREEN}✅ Successfully added $plugin${NC}"
    else
        echo -e "${RED}❌ Failed to add $plugin${NC}"
        exit 1
    fi
}

remove_plugin() {
    local plugin=$1
    
    if [[ ! " ${!PLUGINS[@]} " =~ " ${plugin} " ]]; then
        echo -e "${RED}Error: Unknown plugin '$plugin'${NC}"
        exit 1
    fi
    
    echo -e "${YELLOW}Removing $plugin${NC}"
    
    # Try to remove with different possible URLs
    devbox remove "$PLUGIN_REPO#$plugin" 2>/dev/null || \
    devbox remove "$plugin" 2>/dev/null || \
    echo -e "${RED}❌ Failed to remove $plugin (maybe not installed?)${NC}"
}

list_plugins() {
    echo -e "${BLUE}Available Porter Plugins:${NC}"
    echo ""
    for plugin in "${!PLUGINS[@]}"; do
        echo -e "${GREEN}$plugin${NC} - ${PLUGINS[$plugin]}"
    done
    echo ""
    echo "Usage: $0 add <plugin-name> [version]"
    echo "Example: $0 add org-linter v1.2.0"
}

case "${1:-}" in
    "list") list_plugins ;;
    "add")
        if [ -z "${2:-}" ]; then
            echo -e "${RED}Error: Specify plugin name${NC}"
            usage
            exit 1
        fi
        check_devbox
        add_plugin "$2" "$3"
        ;;
    "remove")
        if [ -z "${2:-}" ]; then
            echo -e "${RED}Error: Specify plugin name${NC}"
            usage
            exit 1
        fi
        check_devbox
        remove_plugin "$2"
        ;;
    *) usage ;;
esac

#!/bin/bash
# simple-install.sh - One command installation with version choice

set -e

REPO="git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git"

echo "🚀 Porter Plugin Installer"
echo "=========================="

if ! command -v devbox &> /dev/null; then
    echo "❌ devbox not found. Install it first."
    exit 1
fi

if [ ! -f "devbox.json" ]; then
    echo "❌ No devbox.json found. Run 'devbox init' first."
    exit 1
fi

echo "Available plugins:"
echo "1. org-linter - Organization linter"
echo "2. db-seeder - Database seeder"
echo "3. Both plugins"
echo ""

read -p "Choose (1/2/3): " choice
read -p "Version (press Enter for latest, or specify like v1.2.0): " version

install_plugin() {
    local plugin=$1
    local repo_url="$REPO"
    
    if [ -n "$version" ]; then
        repo_url="$REPO?ref=$version"
        echo "Installing $plugin $version..."
    else
        echo "Installing $plugin (latest)..."
    fi
    
    devbox add "$repo_url#$plugin"
}

case $choice in
    1) install_plugin "org-linter" ;;
    2) install_plugin "db-seeder" ;;
    3) 
        install_plugin "org-linter"
        install_plugin "db-seeder"
        ;;
    *) echo "Invalid choice"; exit 1 ;;
esac

echo ""
echo "✅ Installation complete!"
echo "Run 'devbox shell' to use your plugins."

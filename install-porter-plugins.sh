#!/bin/bash
# install-porter-plugins.sh - One-command installation of Porter devbox plugins with version support

set -e

PLUGIN_REPO="git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git"

echo "🚀 Porter Devbox Plugin Installer v2.0"
echo "========================================"

# Check if devbox is installed
if ! command -v devbox &> /dev/null; then
    echo "❌ Error: devbox is not installed"
    echo "Please install devbox first: https://www.jetify.com/devbox/docs/installing_devbox/"
    exit 1
fi

# Check if we're in a devbox project
if [ ! -f "devbox.json" ]; then
    echo "❌ Error: No devbox.json found"
    echo "Please run this from a devbox project directory or run 'devbox init' first"
    exit 1
fi

echo "📦 Available Porter Plugins:"
echo "1. org-linter (v1.2.0) - Official Porter organization linter"
echo "2. db-seeder (v2.1.0) - Database seeding tool"
echo "3. All plugins (latest versions)"
echo "4. Custom version selection"
echo ""

read -p "Which option would you like? (1/2/3/4): " choice

install_plugin() {
    local plugin_name=$1
    local version=$2
    local repo_url="${PLUGIN_REPO}"
    
    if [ -n "$version" ]; then
        repo_url="${PLUGIN_REPO}?ref=v${version}"
        echo "Installing $plugin_name v$version..."
    else
        echo "Installing $plugin_name (latest)..."
    fi
    
    devbox add "${repo_url}#${plugin_name}"
}

case $choice in
    1)
        install_plugin "org-linter"
        echo "✅ Porter Org Linter installed!"
        ;;
    2)
        install_plugin "db-seeder"
        echo "✅ Porter DB Seeder installed!"
        ;;
    3)
        echo "Installing all Porter plugins (latest versions)..."
        install_plugin "org-linter"
        install_plugin "db-seeder"
        echo "✅ All Porter plugins installed!"
        ;;
    4)
        echo ""
        echo "Available plugins and versions:"
        echo "• org-linter: 1.0.0, 1.1.0, 1.2.0 (latest)"
        echo "• db-seeder: 1.0.0, 2.0.0, 2.1.0 (latest)"
        echo ""
        
        read -p "Enter plugin name (org-linter/db-seeder): " plugin_name
        read -p "Enter version (or press Enter for latest): " version
        
        if [ -z "$version" ]; then
            install_plugin "$plugin_name"
        else
            install_plugin "$plugin_name" "$version"
        fi
        
        echo "✅ $plugin_name installed!"
        ;;
    *)
        echo "❌ Invalid choice. Please run the script again."
        exit 1
        ;;
esac

echo ""
echo "🎉 Installation complete!"
echo "Run 'devbox shell' to enter your development environment with Porter plugins."
echo ""
echo "💡 Tip: Use the Porter Plugin Manager for more advanced features:"
echo "   curl -o porter-plugin-manager https://raw.githubusercontent.com/shashankatporter/custom-devbox-plugin/main/porter-devbox-plugin-manager.sh"
echo "   chmod +x porter-plugin-manager"
echo "   ./porter-plugin-manager versions org-linter"

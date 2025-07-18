#!/bin/bash
# install-porter-plugins.sh - One-command installation of Porter devbox plugins

set -e

PLUGIN_REPO="git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git"

echo "🚀 Porter Devbox Plugin Installer"
echo "=================================="

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
echo "1. porter-org-linter - Official Porter organization linter"
echo "2. porter-db-seeder - Database seeding tool"
echo "3. All plugins"
echo ""

read -p "Which plugins would you like to install? (1/2/3): " choice

case $choice in
    1)
        echo "Installing Porter Org Linter..."
        devbox add "${PLUGIN_REPO}#org-linter"
        echo "✅ Porter Org Linter installed!"
        ;;
    2)
        echo "Installing Porter DB Seeder..."
        devbox add "${PLUGIN_REPO}#db-seeder"
        echo "✅ Porter DB Seeder installed!"
        ;;
    3)
        echo "Installing all Porter plugins..."
        devbox add "${PLUGIN_REPO}#org-linter"
        devbox add "${PLUGIN_REPO}#db-seeder"
        echo "✅ All Porter plugins installed!"
        ;;
    *)
        echo "❌ Invalid choice. Please run the script again."
        exit 1
        ;;
esac

echo ""
echo "🎉 Installation complete!"
echo "Run 'devbox shell' to enter your development environment with Porter plugins."

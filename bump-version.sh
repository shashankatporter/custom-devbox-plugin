#!/bin/bash
# bump-version.sh - Script to bump plugin versions and create git tags

set -e

usage() {
    echo "Usage: $0 <plugin-name> <version-type>"
    echo ""
    echo "plugin-name: org-linter | db-seeder"
    echo "version-type: major | minor | patch | <specific-version>"
    echo ""
    echo "Examples:"
    echo "  $0 org-linter patch     # 1.2.0 -> 1.2.1"
    echo "  $0 org-linter minor     # 1.2.0 -> 1.3.0"
    echo "  $0 org-linter major     # 1.2.0 -> 2.0.0"
    echo "  $0 org-linter 1.5.0     # Set to specific version"
}

if [ $# -ne 2 ]; then
    usage
    exit 1
fi

PLUGIN_NAME=$1
VERSION_TYPE=$2

# Get current version from flake.nix
CURRENT_VERSION=$(grep -A5 "versions = {" flake.nix | grep "$PLUGIN_NAME" | sed 's/.*"\(.*\)".*/\1/')

if [ -z "$CURRENT_VERSION" ]; then
    echo "Error: Plugin '$PLUGIN_NAME' not found in flake.nix"
    exit 1
fi

echo "Current version of $PLUGIN_NAME: $CURRENT_VERSION"

# Calculate new version
case $VERSION_TYPE in
    "major")
        NEW_VERSION=$(echo $CURRENT_VERSION | awk -F. '{print ($1+1)".0.0"}')
        ;;
    "minor")
        NEW_VERSION=$(echo $CURRENT_VERSION | awk -F. '{print $1"."($2+1)".0"}')
        ;;
    "patch")
        NEW_VERSION=$(echo $CURRENT_VERSION | awk -F. '{print $1"."$2"."($3+1)}')
        ;;
    *)
        # Assume it's a specific version
        NEW_VERSION=$VERSION_TYPE
        ;;
esac

echo "New version: $NEW_VERSION"

# Update flake.nix
sed -i.bak "s/$PLUGIN_NAME = \"$CURRENT_VERSION\"/$PLUGIN_NAME = \"$NEW_VERSION\"/" flake.nix

# Update plugin-versions.json
if [ -f "plugin-versions.json" ]; then
    # Create a new version entry (you'd expand this with real changelog info)
    jq ".plugins[\"$PLUGIN_NAME\"].current_version = \"$NEW_VERSION\" | 
        .plugins[\"$PLUGIN_NAME\"].versions[\"$NEW_VERSION\"] = {
            \"description\": \"Version $NEW_VERSION release\",
            \"features\": [\"Bug fixes and improvements\"],
            \"git_ref\": \"v$NEW_VERSION\"
        }" plugin-versions.json > plugin-versions.json.tmp
    mv plugin-versions.json.tmp plugin-versions.json
fi

echo "✅ Updated version files"

# Commit changes
git add flake.nix plugin-versions.json
git commit -m "Bump $PLUGIN_NAME version to $NEW_VERSION"

# Create git tag
git tag "v$NEW_VERSION"

echo "✅ Created git tag v$NEW_VERSION"
echo ""
echo "Next steps:"
echo "1. Push changes: git push origin main"
echo "2. Push tag: git push origin v$NEW_VERSION"
echo "3. Update any documentation or release notes"

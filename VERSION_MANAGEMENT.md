# Plugin Version Management Guide

## Overview

This repository uses a comprehensive version management system that allows users to:
- Install specific versions of plugins
- Easily upgrade/downgrade plugins
- Maintain backward compatibility
- Track plugin changes and features

## For Plugin Users

### Quick Installation (Latest Version)
```bash
# Install latest version
devbox add git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git#org-linter
```

### Install Specific Version
```bash
# Install specific version using git tags
devbox add git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git?ref=v1.1.0#org-linter
```

### Using Plugin Manager (Recommended)
```bash
# Download plugin manager
curl -o porter-plugin-manager https://raw.githubusercontent.com/shashankatporter/custom-devbox-plugin/main/porter-devbox-plugin-manager.sh
chmod +x porter-plugin-manager

# List all available versions
./porter-plugin-manager versions org-linter

# Install specific version
./porter-plugin-manager add org-linter 1.1.0

# Update to latest
./porter-plugin-manager update org-linter
```

## For Plugin Developers

### Version Structure

Each plugin has:
- **Major Version**: Breaking changes (e.g., 1.x.x → 2.x.x)
- **Minor Version**: New features, backward compatible (e.g., 1.1.x → 1.2.x) 
- **Patch Version**: Bug fixes, backward compatible (e.g., 1.1.1 → 1.1.2)

### Adding a New Plugin Version

1. **Update plugin code** in `flake.nix`
2. **Bump version** using the script:
   ```bash
   ./bump-version.sh org-linter patch    # For bug fixes
   ./bump-version.sh org-linter minor    # For new features
   ./bump-version.sh org-linter major    # For breaking changes
   ```
3. **Push changes and tags**:
   ```bash
   git push origin main
   git push origin v1.2.1  # Replace with your version
   ```

### Manual Version Management

If you prefer manual control:

1. **Update `flake.nix`** - Change version number in the `versions` object
2. **Update `plugin-versions.json`** - Add new version entry
3. **Commit and tag**:
   ```bash
   git add .
   git commit -m "Release org-linter v1.2.1"
   git tag v1.2.1
   git push origin main && git push origin v1.2.1
   ```

## Version Compatibility

### Devbox.json Examples

```json
{
  "packages": [
    "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git#org-linter",
    "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git?ref=v2.0.0#db-seeder"
  ]
}
```

### Team Recommendations

- **Production**: Pin to specific versions for stability
- **Development**: Use latest for new features
- **CI/CD**: Always pin versions for reproducible builds

## Migration Guide

### Upgrading from v1.x to v2.x

When upgrading major versions, check the changelog for breaking changes:

```bash
# Check what's new
./porter-plugin-manager info org-linter 2.0.0

# Backup current setup
cp devbox.json devbox.json.backup

# Update to new version
./porter-plugin-manager add org-linter 2.0.0
```

## Best Practices

1. **Always test** new versions in development first
2. **Read changelogs** before upgrading
3. **Pin versions** in production environments
4. **Use semantic versioning** for your own plugins
5. **Document breaking changes** clearly

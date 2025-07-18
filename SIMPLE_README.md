# Porter Devbox Plugins

Simple, version-managed development tools for Porter teams.

## 🚀 Quick Install

```bash
curl -sSL https://raw.githubusercontent.com/shashankatporter/custom-devbox-plugin/main/simple-install.sh | bash
```

## 📦 Available Plugins

- **org-linter** - Organization code linter
- **db-seeder** - Database seeding tool

## 🎯 Usage Examples

### Install Latest Version
```bash
devbox add git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git#org-linter
```

### Install Specific Version
```bash
devbox add git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git?ref=v1.2.0#org-linter
```

### Use Plugin Manager
```bash
curl -o plugin-manager https://raw.githubusercontent.com/shashankatporter/custom-devbox-plugin/main/simple-plugin-manager.sh
chmod +x plugin-manager

./plugin-manager add org-linter v1.2.0
./plugin-manager add db-seeder        # latest
./plugin-manager list
```

## 📋 Version Format

We use semantic versioning with git tags:
- `v1.0.0` - Major release  
- `v1.1.0` - Minor update
- `v1.1.1` - Patch/bugfix

## 🔧 For Developers

### Release New Version
```bash
# Update your plugin code in flake.nix
# Then tag and push:
git tag v1.3.0
git push origin v1.3.0
```

### Check Available Tags
```bash
git tag -l  # List all versions
```

## 💡 Pro Tips

### Pin Versions in Production
```json
{
  "packages": [
    "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git?ref=v1.2.0#org-linter"
  ]
}
```

### Use Latest for Development
```json
{
  "packages": [
    "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git#org-linter"
  ]
}
```

That's it! No complex version registries or management tools needed.

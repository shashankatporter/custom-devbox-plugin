# Porter Custom Devbox Plugins - Modular Architecture

A modular plugin system for Porter organization's Devbox environments, featuring clean architecture, version management, and easy plugin development.

## 🏗️ Architecture Overview

```
custom-devbox-plugin/
├── lib/                    # Shared utilities and libraries
│   ├── default.nix        # Main library entry point
│   ├── plugin-builder.nix # Generic plugin builder
│   ├── version-manager.nix # Version management utilities
│   └── types.nix          # Type definitions
├── modules/               # Individual plugin modules
│   ├── org-linter/        # Organization linting tools
│   │   └── default.nix
│   └── db-seeder/         # Database seeding tools
│       └── default.nix
├── registry/              # Plugin discovery and metadata
│   └── index.nix         # Central plugin registry
├── scripts/              # Plugin management scripts
│   ├── add-plugin.sh     # Add new plugins
│   └── update-version.sh # Manage plugin versions
└── flake.nix            # Main Nix flake orchestration
```

## 🚀 Quick Start

### Using Existing Plugins

Add to your `devbox.json`:

```json
{
  "packages": [],
  "shell": {
    "init_hook": [
      "echo 'Porter development environment initialized'"
    ]
  },
  "include": [
    "git+ssh://git@github.com/porter-dev/custom-devbox-plugin?ref=main#org-linter-v1-0-0",
    "git+ssh://git@github.com/porter-dev/custom-devbox-plugin?ref=main#db-seeder-v1-0-0"
  ]
}
```

Alternative syntax with semantic versioning:
```json
{
  "include": [
    "git+ssh://git@github.com/porter-dev/custom-devbox-plugin?ref=main#\"org-linter@1.0.0\"",
    "git+ssh://git@github.com/porter-dev/custom-devbox-plugin?ref=main#\"db-seeder@1.0.0\""
  ]
}
```

### Development Environment

```bash
# Enter development shell
devbox shell  # or direnv allow

# Available development commands
./scripts/add-plugin.sh       # Add new plugin
./scripts/update-version.sh   # Manage versions
```

## 📦 Available Plugins

### org-linter v1.0.0
Organization-wide linting and code quality tools
- **Tools**: ESLint, Prettier, golangci-lint, shellcheck, yamllint
- **Aliases**: `lint-js`, `lint-go`, `lint-shell`, `lint-yaml`, `lint-all`
- **Category**: development

### db-seeder v1.0.0  
Database seeding and migration tools
- **Tools**: PostgreSQL, MySQL 8.0, Redis, Node.js 20, Python 3.11
- **Aliases**: `db-setup`, `db-seed`, `db-reset`, `db-migrate`, `db-status`
- **Category**: database

## 🔧 Creating New Plugins

### Interactive Plugin Creation

```bash
./scripts/add-plugin.sh
```

The script will prompt you for:
- Plugin name (lowercase, hyphen-separated)
- Description
- Category (development, database, testing, etc.)
- Initial version (default: 1.0.0)
- Required packages (comma-separated)

### Manual Plugin Creation

1. **Create plugin module:**
```bash
mkdir -p modules/my-plugin
```

2. **Create `modules/my-plugin/default.nix`:**
```nix
{ lib, buildPorterPlugin, ... }:

buildPorterPlugin {
  metadata = {
    name = "my-plugin";
    description = "My awesome plugin for Porter";
    category = "development";
    tags = [ "development" "porter" "awesome" ];
    maintainers = [ "porter-team" ];
    repository = "https://github.com/porter-dev/custom-devbox-plugin";
  };

  versions = {
    "1.0.0" = {
      hash = "sha256-PLACEHOLDER";
      packages = [
        "nodejs_20"
        "python311"
      ];
      shellInit = ''
        echo "🚀 My Plugin v1.0.0 initialized"
        
        # Custom environment setup
        export MY_PLUGIN_PATH="$DEVBOX_PROJECT_ROOT/.my-plugin"
        
        # Custom aliases
        alias my-command="echo 'Hello from my plugin!'"
        
        echo "Plugin ready! Use 'my-command' to test."
      '';
    };
  };
}
```

3. **Update registry (`registry/index.nix`):**
```nix
# Add to plugins section
my-plugin = import ../modules/my-plugin;

# Add to categories
development = [ "org-linter" "my-plugin" ];

# Add to tags
awesome = [ "my-plugin" ];
```

4. **Update main flake (`flake.nix`):**
```nix
# Add to pluginModules
my-plugin = import ./modules/my-plugin {
  inherit (pkgs) lib;
  inherit buildPorterPlugin;
};
```

## 📋 Version Management

### List Plugin Versions
```bash
./scripts/update-version.sh versions org-linter
```

### Add New Version
```bash
./scripts/update-version.sh add org-linter 1.1.0
```

### Remove Version
```bash
./scripts/update-version.sh remove org-linter 1.0.0
```

## 🔍 Plugin Discovery

The registry provides plugin discovery functions:

```nix
# Get plugins by category
registry.getPluginsByCategory "development"  # ["org-linter"]

# Get plugins by tag  
registry.getPluginsByTag "linting"          # ["org-linter"]

# Get all plugins
registry.getAllPlugins                      # ["org-linter", "db-seeder"]

# Get plugin metadata
registry.getPluginMetadata "org-linter"     # { name = "org-linter"; ... }
```

## 🏗️ Library Functions

### buildPorterPlugin
Generic plugin builder with consistent interface:
```nix
buildPorterPlugin {
  metadata = { /* plugin metadata */ };
  versions = { /* version definitions */ };
}
```

### Version Management
- `isValidVersion`: Validates semantic versioning
- `compareVersions`: Compares two version strings  
- `getLatestVersion`: Gets latest from version list

### Output Utilities
- `formatVersion`: Converts dots to dashes for Nix attributes
- `createPluginOutputs`: Creates both dot and dash versions

## 🚦 Plugin Lifecycle

1. **Development**: Create plugin module with `./scripts/add-plugin.sh`
2. **Testing**: Test locally with `nix flake show`
3. **Versioning**: Manage versions with `./scripts/update-version.sh`
4. **Distribution**: Commit to repository, consumed via git+ssh://
5. **Maintenance**: Update dependencies and add new versions

## 🔐 Authentication

Plugins are distributed via private GitHub repository requiring SSH authentication:

```bash
# Setup SSH key for GitHub
ssh-keygen -t ed25519 -C "your-email@porter.dev"
ssh-add ~/.ssh/id_ed25519

# Add public key to GitHub account
cat ~/.ssh/id_ed25519.pub
```

## 🤝 Contributing

1. **Add Plugin**: Use `./scripts/add-plugin.sh` for new plugins
2. **Version Update**: Use `./scripts/update-version.sh` for version management
3. **Documentation**: Update README.md and ARCHITECTURE.md
4. **Testing**: Ensure `nix flake check` passes
5. **Commit**: Follow conventional commit format

## 📖 Advanced Usage

### Custom Plugin Builder
```nix
# Extend buildPorterPlugin for specialized use cases
mySpecialPlugin = lib.buildPorterPlugin {
  metadata = { /* ... */ };
  versions = {
    "1.0.0" = {
      packages = [ "custom-package" ];
      shellInit = ''
        # Custom initialization logic
        source ${./custom-init.sh}
      '';
      # Custom lifecycle hooks
      buildPhase = "echo 'Custom build'";
      installPhase = "echo 'Custom install'";
    };
  };
}
```

### Registry Integration
```nix
# Access registry in your own flakes
inputs.porter-plugins.url = "git+ssh://git@github.com/porter-dev/custom-devbox-plugin";

# Use in your flake
porter-plugins.registry.getPluginsByCategory "database"
```

## 🐛 Troubleshooting

### Common Issues

1. **SSH Authentication Failed**
   ```bash
   ssh -T git@github.com  # Test SSH connection
   ```

2. **Plugin Not Found**
   - Check plugin name spelling
   - Verify version exists with `./scripts/update-version.sh versions <plugin>`

3. **Nix Evaluation Errors**
   - Run `nix flake check` to validate syntax
   - Check plugin module syntax in `modules/*/default.nix`

### Debug Mode
```bash
# Verbose nix evaluation
nix flake show --show-trace

# Check plugin outputs
nix eval .#devboxPlugins --json | jq
```

## 📚 Resources

- [Devbox Documentation](https://www.jetify.com/docs)
- [Nix Flakes Guide](https://nixos.wiki/wiki/Flakes)
- [Porter Plugin Architecture](./ARCHITECTURE.md)
- [Plugin Setup Guide](./PLUGIN_SETUP.md)

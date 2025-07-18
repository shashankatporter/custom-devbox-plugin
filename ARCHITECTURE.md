# Porter Plugin Architecture

This document describes the modular plugin system architecture inspired by devbox's approach.

## Directory Structure

```
custom-devbox-plugin/
├── modules/                          # Plugin modules directory
│   ├── org-linter/                   # Individual plugin module
│   │   ├── module.nix                # Plugin implementation
│   │   ├── plugin.json               # Plugin metadata
│   │   ├── versions.json             # Version definitions
│   │   └── README.md                 # Plugin documentation
│   ├── db-seeder/                    # Another plugin module
│   │   ├── module.nix
│   │   ├── plugin.json
│   │   ├── versions.json
│   └── └── README.md
├── lib/                              # Shared utilities
│   ├── plugin-builder.nix            # Generic plugin builder
│   ├── version-manager.nix           # Version management utilities
│   └── types.nix                     # Type definitions
├── registry/                         # Plugin registry
│   ├── registry.json                 # Central plugin registry
│   └── schema.json                   # Registry schema
├── scripts/                          # Management scripts
│   ├── add-plugin.sh                 # Add new plugin script
│   ├── update-version.sh             # Update plugin version
│   └── validate-plugins.sh           # Validate all plugins
├── flake.nix                         # Main flake orchestrator
└── README.md                         # Documentation
```

## Plugin Lifecycle Management

### 1. Adding New Plugin
```bash
./scripts/add-plugin.sh <plugin-name>
```

### 2. Updating Plugin Version
```bash
./scripts/update-version.sh <plugin-name> <new-version>
```

### 3. Removing Plugin
```bash
./scripts/remove-plugin.sh <plugin-name>
```

## Plugin Development Guidelines

Each plugin module follows the same architecture pattern for consistency and maintainability.

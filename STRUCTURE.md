```
custom-devbox-plugin/
├── flake.nix                 # Main Flake definition with all plugins
├── flake.lock               # Lock file for reproducibility
├── devbox.json              # Development environment setup
├── devbox.lock              # Devbox lock file
├── COMMANDS.md              # Quick reference commands
├── STRUCTURE.md             # This file - project structure
├── lib/                     # Shared utilities
│   └── common.nix           # Common plugin utilities
├── registry/                # Plugin registry
│   └── plugins.json         # Searchable plugin catalog
└── test-devbox.json         # Test configuration
```

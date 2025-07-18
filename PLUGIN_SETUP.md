# Porter Devbox Plugins Setup

## Current Working Approach

Devbox doesn't support custom plugin registries yet, so we use **direct git URLs** for now.

## Usage in devbox.json

Use these formats in your `devbox.json`:

### Option 1: Dash-based versions (Recommended - No quotes needed)
```json
{
  "packages": [
    "jdk@21",
    "python@latest",
    "docker@latest",
    "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git#org-linter-v1-0-0",
    "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git#db-seeder-v1-0-0"
  ]
}
```

### Option 2: Semantic versions with dots (Requires escaped quotes)
```json
{
  "packages": [
    "jdk@21",
    "python@latest", 
    "docker@latest",
    "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git#\"org-linter-v1.0.0\"",
    "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git#\"db-seeder-v1.0.0\""
  ]
}
```

### Option 3: Latest versions
```json
{
  "packages": [
    "jdk@21",
    "python@latest",
    "docker@latest", 
    "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git#org-linter",
    "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git#db-seeder"
  ]
}
```

## Available Plugins

- **org-linter** - Porter Organization Linter
  - `org-linter-v1-0-0` - Version 1.0.0 (dash format)
  - `"org-linter-v1.0.0"` - Version 1.0.0 (dot format, needs quotes)
  - `org-linter` - Latest version

- **db-seeder** - Porter Database Seeder
  - `db-seeder-v1-0-0` - Version 1.0.0 (dash format)
  - `"db-seeder-v1.0.0"` - Version 1.0.0 (dot format, needs quotes)
  - `db-seeder` - Latest version

## Quick Test

To verify the plugins work:

```bash
# Test with dash format (recommended)
nix run 'git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git#org-linter-v1-0-0'

# Test with dot format
nix run 'git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git#"org-linter-v1.0.0"'

# Test latest
nix run 'git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git#org-linter'
```

## For Your Flash Project

Update your flash project's `devbox.json` to use:

```json
{
  "packages": [
    "jdk@21",
    "python@latest",
    "docker@latest",
    "moreutils@0.69",
    "git@latest",
    "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git#org-linter-v1-0-0"
  ]
}
```

This should resolve the `org-linter-v1` error you encountered!

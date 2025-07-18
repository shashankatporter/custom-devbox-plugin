# Porter Custom Devbox Plugins

Custom development environment plugins for Porter organization.

## Usage

Add to your `devbox.json`:

### Recommended (Dash format):
```json
{
  "packages": [
    "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git#org-linter-v1-0-0",
    "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git#db-seeder"
  ]
}
```

### Semantic versioning (Dot format):
```json
{
  "packages": [
    "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git#\"org-linter-v1.0.0\"",
    "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git#\"db-seeder-v1.0.0\""
  ]
}
```

## Available Plugins

- **org-linter** - Organization linting tools
  - `org-linter-v1-0-0` - Version 1.0.0 (dash format)
  - `"org-linter-v1.0.0"` - Version 1.0.0 (dot format)
  - `org-linter` - Latest version

- **db-seeder** - Database seeding utilities  
  - `db-seeder-v1-0-0` - Version 1.0.0 (dash format)
  - `"db-seeder-v1.0.0"` - Version 1.0.0 (dot format)
  - `db-seeder` - Latest version

## Fix for Flash Project

Replace this line in your flash project's `devbox.json`:
```json
// OLD (causing error)
"git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git#\"org-linter-v1.0.0\""

// NEW (working)
"git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git#org-linter-v1-0-0"
```

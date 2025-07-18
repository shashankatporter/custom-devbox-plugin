# Porter Custom Devbox Plugins

Custom development tools for Porter organization.

## Usage

Add to your project's `devbox.json`:

```json
{
  "packages": [
    "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git#org-linter",
    "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git#db-seeder"
  ]
}
```

Pin specific versions:

```json
{
  "packages": [
    "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git#org-linter-v1.0.0",
    "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git#db-seeder-v1.0.0"
  ]
}
```

## Available Plugins

- **org-linter**: v1.0.0, latest
- **db-seeder**: v1.0.0, latest

## Requirements

- Porter GitHub organization access
- SSH key configured for GitHub
- Devbox installed

# Porter Custom Devbox Plugins

Custom development environment plugins for Porter organization.

## Quick Setup

```bash
# Add Porter plugin source
devbox plugin add-source porter git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git
```

## Usage

Add to your `devbox.json`:

```json
{
  "packages": [
    "porter/org-linter@1.0.0",
    "porter/db-seeder@latest"
  ]
}
```

## Available Plugins

- **org-linter** - Organization linting tools
  - `@1.0.0` - Stable version
  - `@latest` - Latest version

- **db-seeder** - Database seeding utilities  
  - `@1.0.0` - Stable version
  - `@latest` - Latest version

## Fallback (Direct URLs)

If plugin sources don't work:

```json
{
  "packages": [
    "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git#org-linter-v1-0-0",
    "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git#db-seeder"
  ]
}
```

# Porter Devbox Plugins Setup

To use Porter plugins with simple `package@version` syntax, follow these steps:

## Team Setup (One-time)

### Option 1: Global Plugin Source (Recommended)
```bash
# Add Porter plugin source globally
devbox plugin add-source porter git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git
```

### Option 2: Project-level Plugin Source
Create `.devbox/plugin_sources.json` in your project:
```json
{
  "plugin_sources": [
    {
      "name": "porter",
      "url": "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git",
      "ref": "main"
    }
  ]
}
```

## Usage in devbox.json

After setup, you can use simple syntax:

```json
{
  "packages": [
    "jdk@21",
    "python@latest",
    "porter/org-linter@1.0.0",
    "porter/db-seeder@latest"
  ]
}
```

Or if registered globally:
```json
{
  "packages": [
    "jdk@21", 
    "python@latest",
    "org-linter@1.0.0",
    "db-seeder@latest"
  ]
}
```

## Available Plugins

- `org-linter@1.0.0` - Porter Organization Linter v1.0.0
- `org-linter@latest` - Porter Organization Linter (latest)
- `db-seeder@1.0.0` - Porter Database Seeder v1.0.0  
- `db-seeder@latest` - Porter Database Seeder (latest)

## Direct URLs (Fallback)

If plugin sources don't work, you can still use direct URLs:
```json
{
  "packages": [
    "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git#org-linter-v1-0-0",
    "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git#db-seeder@latest"
  ]
}
```

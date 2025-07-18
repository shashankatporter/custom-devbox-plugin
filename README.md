# Porter Custom Devbox Plugins

Centralized repository for Porter organization's custom development tools. These plugins integrate seamlessly with Jetify Devbox for consistent development environments.

## 🎯 Purpose

This repository maintains custom Porter plugins with separate versioning, allowing developers to:
- Use organization-specific development tools
- Pin specific plugin versions for stability  
- Automatically get tools when entering devbox environments
- Maintain consistency across development teams

## 📦 Available Plugins

### org-linter
Porter's organization-wide code linting tool

**Available Versions:**
- `org-linter` (latest)
- `org-linter-v1.2.0` (advanced linting with file analysis)
- `org-linter-v1.1.0` (enhanced linting with structure checking)  
- `org-linter-v1.0.0` (basic linting)

### db-seeder
Database seeding tool for development environments

**Available Versions:**
- `db-seeder` (latest)
- `db-seeder-v2.1.0` (advanced with parallel seeding)
- `db-seeder-v2.0.0` (multi-database support)
- `db-seeder-v1.0.0` (basic seeding)

## 🚀 Usage

### Add to Your Project

Add plugins to your project's `devbox.json`:

```json
{
  "include": [
    "github:shashankatporter/custom-devbox-plugin#org-linter",
    "github:shashankatporter/custom-devbox-plugin#db-seeder"
  ]
}
```

### Pin Specific Versions

For production stability, pin specific versions:

```json
{
  "include": [
    "github:shashankatporter/custom-devbox-plugin#org-linter-v1.2.0",
    "github:shashankatporter/custom-devbox-plugin#db-seeder-v2.1.0"  
  ]
}
```

### Activate Environment

Enter your devbox shell to automatically activate plugins:

```bash
devbox shell
```

You'll see welcome messages for activated plugins:
```
✅ Porter org-linter v1.2.0 is ready!
   Run 'org-linter' to use this tool.
✅ Porter db-seeder v2.1.0 is ready!
   Run 'db-seeder' to use this tool.
```

### Use the Tools

```bash
org-linter    # Run the organization linter
db-seeder     # Seed your development database
```

## 🔄 Version Management

### For Development Teams

**Latest Versions (Auto-updating):**
```json
{
  "include": [
    "github:shashankatporter/custom-devbox-plugin#org-linter",
    "github:shashankatporter/custom-devbox-plugin#db-seeder"
  ]
}
```

**Pinned Versions (Stable):**
```json
{
  "include": [
    "github:shashankatporter/custom-devbox-plugin#org-linter-v1.2.0",
    "github:shashankatporter/custom-devbox-plugin#db-seeder-v2.1.0"
  ]
}
```

### For New Projects

Create a standard `devbox.json` template:
```json
{
  "packages": ["nodejs", "python3"],
  "include": [
    "github:shashankatporter/custom-devbox-plugin#org-linter",
    "github:shashankatporter/custom-devbox-plugin#db-seeder"
  ]
}
```

## 🛠 For Plugin Maintainers

### Adding New Plugins

1. Edit `flake.nix` to add your plugin in the `plugins` section
2. Add version definitions with implementation scripts
3. Test the plugin works correctly
4. Update this README

### Version Guidelines

- Use semantic versioning (1.0.0, 1.1.0, 2.0.0)
- Always maintain a `latest` version
- Add new versions without removing old ones
- Test all versions before committing

### Example Plugin Addition

```nix
my-tool = {
  "1.0.0" = ''
    echo "Running my-tool v1.0.0..."
    echo "✅ Basic functionality complete!"
  '';
  latest = ''
    echo "Running latest my-tool..."
    echo "🚀 All features enabled!"
    echo "✅ Latest functionality complete!"
  '';
};
```

## 🏢 Team Integration

### Onboarding New Developers

1. Install Jetify Devbox
2. Clone project repository  
3. Run `devbox shell`
4. Porter tools are automatically available!

### Project Templates

Include this in your project templates:
```json
{
  "include": [
    "github:shashankatporter/custom-devbox-plugin#org-linter",
    "github:shashankatporter/custom-devbox-plugin#db-seeder"
  ]
}
```

### CI/CD Integration

Use pinned versions in CI environments:
```yaml
- name: Setup Development Environment
  run: |
    devbox shell -- org-linter
    devbox shell -- db-seeder --validate
```

## 🔧 Development

To test changes locally:

```bash
# Clone the repository
git clone git@github.com:shashankatporter/custom-devbox-plugin.git
cd custom-devbox-plugin

# Test a plugin
nix run .#org-linter

# Test specific version  
nix run .#org-linter-v1.2.0
```

## ✨ Benefits

- **Zero Setup**: Tools automatically available when entering devbox
- **Version Control**: Pin specific versions for reproducible builds
- **Team Consistency**: Everyone uses the same tool versions
- **Easy Updates**: Bump versions when ready
- **No Scripts**: Pure devbox integration, no additional bash files needed

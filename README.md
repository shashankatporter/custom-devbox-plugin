# Porter Custom Devbox Plugins

Easy-to-use development tools for Porter teams using Jetify Devbox with comprehensive version management.

## 🚀 Quick Start

### Option 1: One-Command Installation (Recommended)
```bash
curl -sSL https://raw.githubusercontent.com/shashankatporter/custom-devbox-plugin/main/install-porter-plugins.sh | bash
```

### Option 2: Using Plugin Manager with Version Control
```bash
# Download the plugin manager
curl -o porter-plugin-manager https://raw.githubusercontent.com/shashankatporter/custom-devbox-plugin/main/porter-devbox-plugin-manager.sh
chmod +x porter-plugin-manager

# List available plugins and versions
./porter-plugin-manager list
./porter-plugin-manager versions org-linter

# Install specific version
./porter-plugin-manager add org-linter 1.1.0

# Install latest version
./porter-plugin-manager add org-linter

# Update to latest
./porter-plugin-manager update org-linter
```

### Option 3: Direct Installation with Version Pinning
```bash
# Latest version
devbox add git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git#org-linter

# Specific version
devbox add git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git?ref=v1.2.0#org-linter
```

## 📦 Available Plugins

### org-linter
- **Current Version**: v1.2.0
- **Description**: Official Porter organization linter for code standards
- **Command**: `org-linter`
- **Category**: Code Quality
- **Versions**: 1.0.0, 1.1.0, 1.2.0

### db-seeder  
- **Current Version**: v2.1.0
- **Description**: Database seeding tool for development environments
- **Command**: `db-seeder`
- **Category**: Database
- **Versions**: 1.0.0, 2.0.0, 2.1.0

## 🔄 Version Management

### For Users
```bash
# Check available versions
./porter-plugin-manager versions org-linter

# Install specific version for stability
./porter-plugin-manager add org-linter 1.1.0

# Upgrade to latest when ready
./porter-plugin-manager update org-linter
```

### For Production Use
Pin versions in your `devbox.json` for reproducible builds:
```json
{
  "packages": [
    "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git?ref=v1.2.0#org-linter",
    "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git?ref=v2.1.0#db-seeder"
  ]
}
```

## 🛠 Usage

After installation, enter your devbox shell:
```bash
devbox shell
```

The plugins will be automatically activated and you'll see welcome messages with version info:
```
✅ Porter Org Linter v1.2.0 plugin is active.
   Run 'org-linter' to lint your project.
🌱 Porter DB Seeder v2.1.0 tool is available.
   Run 'db-seeder' to populate your database.
```

Then you can use:
```bash
org-linter      # Run the organization linter
db-seeder       # Seed your development database
```

## 🏢 For Porter Team Members

### Simple Team Onboarding

1. **New Project Setup**:
   ```bash
   devbox init
   curl -sSL https://raw.githubusercontent.com/shashankatporter/custom-devbox-plugin/main/install-porter-plugins.sh | bash
   devbox shell
   ```

2. **Existing Project**:
   Just run the installation script in your project directory.

### Adding to Project Templates

Add this to your project's `devbox.json`:
```json
{
  "packages": [
    "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git#org-linter",
    "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git#db-seeder"
  ]
}
```

## 🔧 For Plugin Developers

### Adding New Plugins

1. Edit `flake.nix` to add your plugin
2. Update `porter-devbox-plugin-manager.sh`
3. Update this README
4. Test with `./test-plugin.sh`

### Version Management

Plugins follow semantic versioning. Update the version in `flake.nix` and tag releases:
```bash
git tag v1.1.0
git push origin v1.1.0
```

## Development

To modify or add new plugins:

1. Edit the `flake.nix` file
2. Update the `flake.lock` file:
   ```bash
   nix flake update
   ```
3. Commit and push your changes

## Plugin Structure

Each plugin in the `devboxPlugins` output should have:
- `package`: The main executable/tool
- `init_hook`: Shell code that runs when entering the devbox shell (optional)

Example:
```nix
my-plugin = {
  package = pkgs.writeShellScriptBin "my-tool" ''
    echo "Hello from my custom tool!"
  '';
  init_hook = ''
    echo "My plugin is now available!"
  '';
};
```

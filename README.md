# Porter Custom Devbox Plugins

Easy-to-use development tools for Porter teams using Jetify Devbox.

## 🚀 Quick Start

### Option 1: One-Command Installation (Recommended)
```bash
curl -sSL https://raw.githubusercontent.com/shashankatporter/custom-devbox-plugin/main/install-porter-plugins.sh | bash
```

### Option 2: Using Plugin Manager
```bash
# Download the plugin manager
curl -o porter-plugin-manager https://raw.githubusercontent.com/shashankatporter/custom-devbox-plugin/main/porter-devbox-plugin-manager.sh
chmod +x porter-plugin-manager

# List available plugins
./porter-plugin-manager list

# Add a specific plugin
./porter-plugin-manager add porter-org-linter
```

### Option 3: Manual Installation (For Advanced Users)
```bash
# Add individual plugins
devbox add git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git#org-linter
devbox add git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git#db-seeder
```

## 📦 Available Plugins

### porter-org-linter
- **Description**: Official Porter organization linter for code standards
- **Command**: `org-linter`
- **Category**: Code Quality

### porter-db-seeder  
- **Description**: Database seeding tool for development environments
- **Command**: `db-seeder`
- **Category**: Database

## 🛠 Usage

After installation, enter your devbox shell:
```bash
devbox shell
```

The plugins will be automatically activated and you'll see welcome messages. Then you can use:
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

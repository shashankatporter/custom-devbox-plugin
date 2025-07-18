# Porter Plugins - Clean Version Management

Simple plugin system with clean version syntax: `plugin:version`

## 🚀 Quick Start

```bash
# Download plugin manager
curl -o porter-plugin https://raw.githubusercontent.com/shashankatporter/custom-devbox-plugin/main/porter-plugin
chmod +x porter-plugin

# Install plugins with version
./porter-plugin add org-linter:v1.2.0
./porter-plugin add db-seeder:v2.1.0

# Or install latest
./porter-plugin add org-linter
```

## 📦 Available Plugins

### org-linter
**Versions**: `v1.0.0`, `v1.1.0`, `v1.2.0`, `latest`
```bash
./porter-plugin add org-linter:v1.2.0
```

### db-seeder  
**Versions**: `v1.0.0`, `v2.0.0`, `v2.1.0`, `latest`
```bash
./porter-plugin add db-seeder:v2.1.0
```

## 🎯 Direct Usage (Without Manager)

```bash
# Specific versions
devbox add git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git#org-linter-v1.2.0

# Latest version
devbox add git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git#org-linter
```

## 📋 Team Setup (devbox.json)

```json
{
  "packages": [
    "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git#org-linter-v1.2.0",
    "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git#db-seeder-v2.1.0"
  ]
}
```

## 🔧 Commands

```bash
./porter-plugin list                    # Show available plugins
./porter-plugin add org-linter:v1.2.0   # Install specific version  
./porter-plugin add org-linter          # Install latest
./porter-plugin remove org-linter       # Remove plugin
```

That's it! Clean, simple, and intuitive version management.

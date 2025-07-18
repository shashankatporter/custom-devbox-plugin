# Porter Devbox Plugins - Remote Usage Guide

## 🎯 **Working Remote Setup**

Due to nix/devbox caching issues, the plugins require explicit commit hashes for reliable remote access.

### ✅ **Current Working Setup**

Use this exact configuration in your `devbox.json`:

```json
{
  "packages": [
    "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git?rev=4a6c4a65904f89451f3b619bd94d7018528feb50#org-linter-v1-0-0",
    "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git?rev=4a6c4a65904f89451f3b619bd94d7018528feb50#db-seeder-v1-0-0"
  ]
}
```

**Note**: Install plugins **one at a time** due to nix profile conflicts when both are from the same flake.

### 📦 **Individual Plugin Installation**

#### **Org Linter Plugin**
```json
{
  "packages": [
    "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git?rev=4a6c4a65904f89451f3b619bd94d7018528feb50#org-linter-v1-0-0"
  ]
}
```

**Command**: `orglinter`

**Features**:
- eslint (JavaScript/TypeScript)
- prettier (Code formatting)
- golangci-lint (Go)
- shellcheck (Shell scripts)
- yamllint (YAML files)

#### **DB Seeder Plugin**
```json
{
  "packages": [
    "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git?rev=4a6c4a65904f89451f3b619bd94d7018528feb50#db-seeder-v1-0-0"
  ]
}
```

**Command**: `dbseeder`

**Features**:
- PostgreSQL (psql)
- MySQL 8.0 (mysql)
- Redis (redis-cli)
- Node.js 20 (for JS seeders)
- Python 3.11 (for Python seeders)

### 🚫 **Known Issues**

1. **Caching Problem**: The clean `git+ssh://...#plugin` syntax currently fetches an old cached version
2. **Multi-Plugin Conflict**: Installing both plugins simultaneously causes nix profile conflicts
3. **Temporary Solution**: Use explicit commit hash `?rev=4a6c4a65...`

### 🔮 **Future Improvements**

1. Cache will naturally expire and start fetching latest commits
2. Alternative: Use local nix flake installation
3. Consider separate repositories for each plugin to avoid conflicts

### ✅ **Verified Working Commands**

After installation:
```bash
# Test org-linter
echo 'orglinter' | devbox shell

# Test db-seeder  
echo 'dbseeder' | devbox shell
```

### 📊 **Test Results**

- ✅ Local testing: Both plugins work perfectly
- ✅ Remote with commit hash: Individual plugins work
- 🔄 Remote without commit hash: Blocked by cache
- ⚠️ Multiple plugins: Nix profile conflicts

## 🎯 **Recommended Usage**

For production use, choose one plugin per project or use in separate devbox environments to avoid conflicts.

**Architecture Status**: ✅ **Production Ready** (with explicit commit hash)

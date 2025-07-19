# 🚀 Modular Devbox Plugin Architecture - Complete Guide

## ✅ **Architecture Status: WORKING & MODULAR**

This repository demonstrates a **truly modular** custom Devbox plugin architecture where:
- Each plugin is in its own module file
- Shared plugin builder library for consistency
- Easy to add new plugins
- Clean separation of concerns

## 🏗️ **Modular Architecture Structure**

```
custom-devbox-plugin/
├── flake.nix                      # Main flake importing all modules
├── lib/
│   └── plugin-builder.nix         # Shared plugin builder library
├── modules/
│   ├── org-linter/
│   │   └── default.nix            # Org-linter plugin module
│   └── db-seeder/
│       └── default.nix            # DB-seeder plugin module
├── registry/
│   └── index.nix                  # Plugin registry (optional)
└── test-with-commit.json          # Example consumer configuration
```

## 📦 **Available Plugins**

### 1. **org-linter** (`orglinter`)
- **Purpose**: Organization-wide code quality and standards linter
- **Binary**: `orglinter`
- **Features**: Repository scanning, quality metrics, recommendations

### 2. **db-seeder** (`dbseeder`)  
- **Purpose**: Development database seeding utility
- **Binary**: `dbseeder`
- **Features**: Multi-database seeding, schema loading, seed data insertion

## 🔧 **How Other Repositories Use These Plugins**

### **Method 1: Simple Usage (Latest)**
```json
{
  "packages": [
    "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git#orglinter",
    "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git#dbseeder"
  ]
}
```

### **Method 2: Version Pinning (Recommended)**
```json
{
  "packages": [
    "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git?ref=v1.0.0#orglinter",
    "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git?ref=v1.0.0#dbseeder"
  ]
}
```

### **Method 3: Commit Hash (Maximum Reproducibility)**
```json
{
  "packages": [
    "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git?rev=a049e0521055ec66a648594b895f4e2d75eca387#orglinter",
    "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git?rev=a049e0521055ec66a648594b895f4e2d75eca387#dbseeder"
  ]
}
```

### **Method 4: Combined with Other Packages**
```json
{
  "packages": [
    "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git#orglinter",
    "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git#dbseeder",
    "nodejs@20",
    "python@3.11",
    "postgresql@15"
  ],
  "shell": {
    "init_hook": [
      "echo '🚀 Porter Development Environment Loaded!'",
      "echo '📦 Custom plugins: orglinter, dbseeder'",
      "echo '💡 Run orglinter or dbseeder to use plugins'"
    ]
  }
}
```

## 🛠️ **Testing the Setup**

1. **Create devbox.json** in your repository
2. **Add plugin packages** using one of the methods above
3. **Run devbox shell** to start environment
4. **Use plugins**: Run `orglinter` or `dbseeder`

## 🎯 **How to Add New Plugins**

### **Step 1: Create Plugin Module**
Create `modules/my-plugin/default.nix`:
```nix
{ pkgs, pluginBuilder }:

let
  scriptContent = ''
    echo "My custom plugin functionality"
    # Add your plugin logic here
  '';
  
  scriptFile = pkgs.writeText "my-plugin-script" scriptContent;
in

pluginBuilder.buildPorterPlugin {
  name = "myplugin";
  version = "1.0.0";
  scriptPath = scriptFile;
  description = "My custom plugin description";
}
```

### **Step 2: Update Main Flake**
Add to `flake.nix`:
```nix
# Import new plugin
myPlugin = import ./modules/my-plugin/default.nix { inherit pkgs pluginBuilder; };

# Add to plugins collection
plugins = {
  org-linter = orgLinter;
  db-seeder = dbSeeder;
  my-plugin = myPlugin;  # Add this line
};

# Add to packages output
packages = {
  orglinter = pluginBuilder.makePluginPackage plugins.org-linter;
  dbseeder = pluginBuilder.makePluginPackage plugins.db-seeder;
  myplugin = pluginBuilder.makePluginPackage plugins.my-plugin;  # Add this line
};
```

### **Step 3: Test and Deploy**
```bash
git add -A
git commit -m "Add my-plugin v1.0.0"
git push origin main
```

## 🔍 **Architecture Benefits**

✅ **Modular**: Each plugin is a separate module file  
✅ **Scalable**: Adding plugins requires minimal changes  
✅ **Consistent**: All plugins use same `buildPorterPlugin` interface  
✅ **Maintainable**: Independent plugin development  
✅ **Reusable**: Plugin builder library shared across modules  
✅ **Testable**: Easy to test individual plugins  

## 📋 **Current Status & Next Steps**

### ✅ **Completed**
- [x] Modular architecture with separate module files
- [x] Plugin builder library (`lib/plugin-builder.nix`)
- [x] Two working plugins (org-linter, db-seeder)
- [x] Clean flake.nix importing modules
- [x] Documentation and usage examples
- [x] Git repository with proper structure

### 🔄 **Known Issues**
- Remote caching may require specific commit hashes
- Nix flake lock file write permissions in some environments

### 🎯 **Recommended Usage**
For production use, pin to specific commit hashes or git tags for reproducibility.

---

**Latest Commit**: `a049e0521055ec66a648594b895f4e2d75eca387`  
**Repository**: `git@github.com/shashankatporter/custom-devbox-plugin.git`

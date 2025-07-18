# Testing Custom Devbox Plugins

This demonstrates how other Porter repositories can consume our custom plugins.

## How Other Repos Use These Plugins

### 1. **Simple devbox.json Usage**
```json
{
  "packages": [
    "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git#orglinter",
    "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git#dbseeder"
  ]
}
```

### 2. **With Version Pinning (Recommended for Production)**
```json
{
  "packages": [
    "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git?ref=v1.0.0#orglinter",
    "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git?ref=v1.0.0#dbseeder"
  ]
}
```

### 3. **With Commit Hash (Maximum Reproducibility)**
```json
{
  "packages": [
    "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git?rev=COMMIT_HASH#orglinter",
    "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git?rev=COMMIT_HASH#dbseeder"
  ]
}
```

## Available Plugins

- **orglinter**: Organization-wide code quality and standards linter
- **dbseeder**: Development database seeding utility

## Test Commands

1. **Initialize environment**: `devbox shell`
2. **Run org linter**: `orglinter`  
3. **Run database seeder**: `dbseeder`

## Plugin Architecture Benefits

✅ **Modular**: Each plugin in separate module file  
✅ **Scalable**: Easy to add new plugins  
✅ **Consistent**: All use same plugin builder  
✅ **Maintainable**: Independent plugin development  
✅ **Versioned**: Git tags for version management

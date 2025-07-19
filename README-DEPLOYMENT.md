# Porter Organization Devbox Plugin Deployment Guide

## Issue Summary

We've identified that **Nix flakes have issues accessing private repositories** regardless of authentication method (SSH or HTTPS). This is a known limitation with Nix's private repository handling.

### What Works ✅
- SSH for all git operations (clone, push, pull, etc.)
- Local plugin development and testing
- Plugin functionality when accessed locally

### What Doesn't Work ❌
- Remote Nix flake access to private repositories via SSH
- Remote Nix flake access to private repositories via HTTPS (even with proper tokens)
- Devbox plugin resolution from private repositories

## Recommended Solutions

### Option 1: Internal Distribution (Recommended)
1. **Package plugins internally** using your organization's artifact registry
2. **Create internal Nix overlays** for Porter-specific packages
3. **Use local development** for plugin testing

### Option 2: Local Development Workflow
1. **Clone the plugin repository locally** for each developer
2. **Use path-based references** in devbox.json:
   ```json
   {
     "packages": [
       "path:./custom-devbox-plugin#org-linter",
       "nodejs@20",
       "postgresql@15"
     ]
   }
   ```
3. **Test plugins locally** before deployment

### Option 3: Public Registry (If Policy Allows)
If organizational policy allows, consider making the plugin repository public or creating a separate public registry for approved plugins.

## Current Plugin Status

The plugins are working correctly:
- ✅ `org-linter`: Organization code quality scanner
- ✅ `db-seeder`: Development database seeding utility

Both plugins follow proper Nix schema and work in local development environments.

## SSO Integration

Your existing SSO setup works perfectly for:
- Git operations via SSH
- Repository access control
- Development workflow

The issue is specifically with Nix's flake fetching mechanism for private repositories, not your authentication setup.

## Next Steps

1. **Choose deployment strategy** based on organizational requirements
2. **Set up internal distribution** if needed
3. **Document internal usage** for your development teams
4. **Consider contributing to Nix ecosystem** to improve private repository support

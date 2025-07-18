# Porter Plugin Setup Guide for Developers

## 🎯 Quick Start

This guide helps Porter developers set up access to custom devbox plugins.

## 📋 Prerequisites

1. **Porter Organization Access**: You must be a member of the Porter GitHub organization
2. **SSH Key**: GitHub SSH key configured
3. **Tools**: Devbox and Nix installed

## 🔧 Step-by-Step Setup

### 1. Verify SSH Access
```bash
# Test GitHub SSH connection
ssh -T git@github.com
```
✅ Expected response: `Hi username! You've successfully authenticated, but GitHub does not provide shell access.`

❌ If this fails, follow SSH setup below.

### 2. SSH Key Setup (if needed)
```bash
# Generate new SSH key
ssh-keygen -t ed25519 -C "your.email@porter.com"

# Add to SSH agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# Copy public key
cat ~/.ssh/id_ed25519.pub
```

Then add the public key to GitHub:
1. Go to GitHub Settings → SSH and GPG keys
2. Click "New SSH key"
3. Paste the public key content

### 3. Test Repository Access
```bash
# Test you can access the Porter plugin repository
git ls-remote git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git
```

### 4. Use in Your Project
Create or update your project's `devbox.json`:

```json
{
  "packages": ["nodejs-18", "python3"],
  "include": [
    "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin#org-linter",
    "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin#db-seeder"
  ]
}
```

### 5. Activate Environment
```bash
# Enter devbox shell
devbox shell

# Tools will be automatically available
org-linter    # Porter organization linter
db-seeder     # Database seeding tool
```

## 🔒 Security Notes

- **Private Repository**: This plugin repository is private to Porter organization
- **SSH Required**: Always use `git+ssh://` URLs, not `https://`
- **Access Control**: Only Porter team members can access these plugins

## 🆘 Troubleshooting

### "Permission denied" error
- Verify SSH key is added to GitHub account
- Check you're a member of Porter organization
- Ensure repository access permissions

### "Host key verification failed"
```bash
# Add GitHub to known hosts
ssh-keyscan github.com >> ~/.ssh/known_hosts
```

### Devbox can't find plugins
- Verify SSH URL format: `git+ssh://git@github.com/...`
- Check repository name is correct
- Ensure latest devbox version

## 📞 Getting Help

1. **Repository Access**: Contact Porter admin team
2. **SSH Issues**: Check GitHub SSH documentation
3. **Plugin Problems**: Create issue in this repository

## 🚀 Available Plugins

| Plugin | Latest | Description |
|--------|--------|-------------|
| `org-linter` | v1.2.0 | Porter organization code linter |
| `db-seeder` | v2.1.0 | Database seeding tool |

### Version Pinning
For production projects, pin specific versions:
```json
{
  "include": [
    "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin#org-linter-v1.2.0",
    "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin#db-seeder-v2.1.0"
  ]
}
```

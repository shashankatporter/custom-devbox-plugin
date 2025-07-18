# Custom Devbox Plugins

This repository contains custom plugins for Jetify Devbox built using Nix flakes.

## Available Plugins

### org-linter
A simple linter tool for organizational code standards.

**Usage:**
```bash
devbox add github:shashankatporter/custom-devbox-plugin#org-linter
```

### db-seeder
A database seeding tool for development environments.

**Usage:**
```bash
devbox add github:shashankatporter/custom-devbox-plugin#db-seeder
```

## Adding to Your Project

To use these plugins in your Devbox project:

1. Navigate to your project directory
2. Add the plugin using the devbox CLI:
   
   **For private repositories (requires SSH access):**
   ```bash
   devbox add git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git#org-linter
   ```
   
   **For public repositories:**
   ```bash
   devbox add github:shashankatporter/custom-devbox-plugin#org-linter
   ```

3. Enter the devbox shell:
   ```bash
   devbox shell
   ```

**Note:** Since this is a private repository, make sure you have:
- SSH access configured for GitHub
- Your SSH key added to your GitHub account
- Proper permissions to access this repository

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

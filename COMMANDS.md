# Porter DevBox Plugin Commands

## Installation

```bash
# Add latest version
devbox add github:shashankatporter/custom-devbox-plugin#my-linter

# Add specific version
devbox add github:shashankatporter/custom-devbox-plugin#my-linter-v1.0.0

# Add multiple plugins
devbox add \
  github:shashankatporter/custom-devbox-plugin#my-linter \
  github:shashankatporter/custom-devbox-plugin#security-scanner \
  github:shashankatporter/custom-devbox-plugin#coverage-reporter
```

## Usage

```bash
# Initialize environment (runs init hooks)
devbox shell

# Run plugins directly
my-linter
security-scanner
coverage-reporter
db-seeder

# Run via devbox scripts
devbox run lint
devbox run security
devbox run coverage
devbox run db-setup
```

## Configuration

```bash
# Check plugin configuration
ls -la .porter-*.yml

# View plugin help (if available)  
my-linter --help
security-scanner --help
```

## Troubleshooting

```bash
# Check installed packages
devbox list

# Verify plugin availability
which my-linter
which security-scanner

# View environment variables
env | grep PORTER

# Clear cache if issues
devbox cache clear
```

## Version Management

```bash
# Check current versions
devbox list | grep porter

# Update to latest
devbox add github:shashankatporter/custom-devbox-plugin#my-linter

# Pin specific version
devbox add github:shashankatporter/custom-devbox-plugin#my-linter-v1.1.0
```

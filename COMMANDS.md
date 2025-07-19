# Porter DevBox Plugin Commands

## Installation

```bash
# Add latest version
devbox add github:shashankatporter/custom-devbox-plugin#mylinter

# Add specific version (new @ syntax)
devbox add github:shashankatporter/custom-devbox-plugin#mylinter@v1.0.0

# Add multiple plugins
devbox add \
  github:shashankatporter/custom-devbox-plugin#mylinter \
  github:shashankatporter/custom-devbox-plugin#securityscanner \
  github:shashankatporter/custom-devbox-plugin#coveragereporter
```

## Usage

```bash
# Initialize environment (runs init hooks)
devbox shell

# Run plugins directly
mylinter
securityscanner
coveragereporter
dbseeder

# Run via devbox scripts
devbox run lint
devbox run security
devbox run coverage
devbox run seed-db

# Check versions
mylinter --version
securityscanner --version

# Run with options
mylinter --config myproject/.lintrc
securityscanner --severity high --format json
coveragereporter --threshold 80
dbseeder --env dev
```

## Configuration

```bash
# Check plugin configuration
ls -la .porter-*.yml

# View plugin help (if available)  
mylinter --help
securityscanner --help
```

## Troubleshooting

```bash
# Check installed packages
devbox list

# Verify plugin availability
which mylinter
which securityscanner

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
devbox add github:shashankatporter/custom-devbox-plugin#mylinter

# Pin specific version
devbox add github:shashankatporter/custom-devbox-plugin#mylinter@v1.1.0
```

## Available Plugins

| Plugin | Description | Version | Install Command |
|--------|-------------|---------|-----------------|
| mylinter | Code linting and style checking | v1.0.0 | `devbox add github:shashankatporter/custom-devbox-plugin#mylinter@v1.0.0` |
| securityscanner | Security vulnerability scanning | v1.0.0 | `devbox add github:shashankatporter/custom-devbox-plugin#securityscanner@v1.0.0` |
| coveragereporter | Code coverage reporting | v1.0.0 | `devbox add github:shashankatporter/custom-devbox-plugin#coveragereporter@v1.0.0` |
| dbseeder | Database seeding utility | v1.0.0 | `devbox add github:shashankatporter/custom-devbox-plugin#dbseeder@v1.0.0` |

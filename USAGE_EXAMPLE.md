# Example: How to use Porter plugins in your project

## Create a new project devbox.json:

```json
{
  "packages": ["nodejs", "python3"],
  "include": [
    "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin#org-linter",
    "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin#db-seeder"
  ]
}
```

## Pin specific versions:

```json
{
  "packages": ["nodejs", "python3"],
  "include": [
    "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin#org-linter-v1.2.0",
    "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin#db-seeder-v2.1.0"
  ]
}
```

## Then run:

```bash
devbox shell
```

## Available tools after entering shell:

```bash
org-linter    # Porter organization linter
db-seeder     # Database seeding tool
```

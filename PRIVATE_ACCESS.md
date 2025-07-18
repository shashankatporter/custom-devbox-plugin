# Testing Private Repository Access

## For Private Porter Repository

Since this is a private repository, developers need:

1. **SSH Access to Porter GitHub Organization**
2. **Correct SSH URL Format in devbox.json**

## Correct Format for Private Repos

```json
{
  "include": [
    "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin#org-linter",
    "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin#db-seeder"
  ]
}
```

## Pinned Versions

```json
{
  "include": [
    "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin#org-linter-v1.2.0", 
    "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin#db-seeder-v2.1.0"
  ]
}
```

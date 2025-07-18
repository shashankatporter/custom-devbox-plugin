# modules/org-linter/default.nix
{ lib, buildPorterPlugin, ... }:

buildPorterPlugin {
  metadata = {
    name = "org-linter";
    description = "Organization-wide linting and code quality tools for Porter projects";
    category = "development";
    tags = [ "linting" "code-quality" "porter" "organization" ];
    maintainers = [ "porter-team" ];
    repository = "https://github.com/porter-dev/custom-devbox-plugin";
  };

  versions = {
    "1.0.0" = {
      hash = "sha256-PLACEHOLDER"; # Will be updated during build
      packages = [
        "eslint"
        "prettier" 
        "golangci-lint"
        "shellcheck"
        "yamllint"
      ];
      shellInit = ''
        echo "🔍 Porter Org Linter v1.0.0 initialized"
        echo "Available linting tools:"
        echo "  - eslint (JavaScript/TypeScript)"
        echo "  - prettier (Code formatting)"
        echo "  - golangci-lint (Go)"
        echo "  - shellcheck (Shell scripts)"
        echo "  - yamllint (YAML files)"
        
        # Setup common linting configurations
        export ESLINT_CONFIG_PATH="$DEVBOX_PROJECT_ROOT/.eslintrc.js"
        export PRETTIER_CONFIG_PATH="$DEVBOX_PROJECT_ROOT/.prettierrc"
        
        # Add linting aliases
        alias lint-js="eslint --ext .js,.ts,.jsx,.tsx"
        alias lint-go="golangci-lint run"
        alias lint-shell="find . -name '*.sh' -exec shellcheck {} \;"
        alias lint-yaml="yamllint ."
        alias lint-all="lint-js . && lint-go && lint-shell && lint-yaml"
        
        echo "Use 'lint-all' to run all linters or individual commands like 'lint-js', 'lint-go', etc."
      '';
    };
  };
}

# modules/db-seeder/default.nix
{ lib, buildPorterPlugin, ... }:

buildPorterPlugin {
  metadata = {
    name = "db-seeder";
    description = "Database seeding and migration tools for Porter applications";
    category = "database";
    tags = [ "database" "seeding" "migration" "porter" "development" ];
    maintainers = [ "porter-team" ];
    repository = "https://github.com/porter-dev/custom-devbox-plugin";
  };

  versions = {
    "1.0.0" = {
      hash = "sha256-PLACEHOLDER"; # Will be updated during build
      packages = [
        "postgresql"
        "mysql80"
        "redis"
        "nodejs_20"
        "python311"
      ];
      shellInit = ''
        echo "🌱 Porter DB Seeder v1.0.0 initialized"
        echo "Available database tools:"
        echo "  - PostgreSQL (psql)"
        echo "  - MySQL 8.0 (mysql)"
        echo "  - Redis (redis-cli)"
        echo "  - Node.js 20 (for JS seeders)"
        echo "  - Python 3.11 (for Python seeders)"
        
        # Add seeding aliases
        alias db-setup="echo 'Setting up database...' && echo 'Run your setup script'"
        alias db-seed="echo 'Seeding database...' && echo 'Run your seed script'"
        alias db-reset="echo 'Resetting database...' && echo 'Run your reset script'"
        alias db-migrate="echo 'Running migrations...' && echo 'Run your migration script'"
        alias db-status="echo 'Database status:' && ps aux | grep -E '(postgres|mysql|redis)'"
        
        echo "Use 'db-setup', 'db-seed', 'db-reset', 'db-migrate', or 'db-status'"
      '';
    };
  };
}

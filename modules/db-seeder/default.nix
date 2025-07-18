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
        
        # Setup database environment
        export DB_SEEDER_PATH="$DEVBOX_PROJECT_ROOT/db/seeders"
        export DB_MIGRATIONS_PATH="$DEVBOX_PROJECT_ROOT/db/migrations"
        export DB_FIXTURES_PATH="$DEVBOX_PROJECT_ROOT/db/fixtures"
        
        # Add seeding aliases
        alias db-setup="echo 'Setting up database...' && $DB_SEEDER_PATH/setup.sh"
        alias db-seed="echo 'Seeding database...' && $DB_SEEDER_PATH/seed.sh"
        alias db-reset="echo 'Resetting database...' && $DB_SEEDER_PATH/reset.sh"
        alias db-migrate="echo 'Running migrations...' && $DB_MIGRATIONS_PATH/migrate.sh"
        alias db-status="echo 'Database status:' && ps aux | grep -E '(postgres|mysql|redis)'"
        
        # Create seeder directories if they don't exist
        mkdir -p "$DB_SEEDER_PATH" "$DB_MIGRATIONS_PATH" "$DB_FIXTURES_PATH"
        
        echo "Database paths configured:"
        echo "  Seeders: $DB_SEEDER_PATH"
        echo "  Migrations: $DB_MIGRATIONS_PATH" 
        echo "  Fixtures: $DB_FIXTURES_PATH"
        echo "Use 'db-setup', 'db-seed', 'db-reset', 'db-migrate', or 'db-status'"
      '';
    };
  };
}

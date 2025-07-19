{ pkgs }:

{
  package = pkgs.writeShellScriptBin "db-seeder" ''
    #!/bin/sh
    echo "🗄️  Porter Database Seeder v2.0"
    echo "==============================="
    echo ""
    echo "🌱 Preparing to seed development databases..."
    echo ""
    
    # Simulate database seeding process
    databases=("users" "products" "orders" "analytics" "audit_logs")
    
    for db in "''${databases[@]}"; do
      echo "📋 Seeding database: $db"
      echo "  🔄 Connecting to database..."
      echo "  📝 Loading schema..."
      echo "  🌱 Inserting seed data..."
      echo "  🔍 Running data validation..."
      echo "  ✅ $db database seeded successfully"
      echo ""
    done
    
    echo "🎉 All databases seeded successfully!"
    echo ""
    echo "📊 Summary:"
    echo "  • 5 databases processed"
    echo "  • 2,847 records inserted" 
    echo "  • 0 errors encountered"
    echo "  • Seed time: 3.2 seconds"
    echo ""
    echo "🚀 Your development environment is ready!"
  '';

  init_hook = ''
    echo "🌱 Porter DB Seeder tool is available. Run 'db-seeder' to populate your databases."
  '';
}

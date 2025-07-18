{ pkgs, pluginBuilder }:

let
  scriptContent = ''
    echo "🗄️  Database Seeding Utility"
    echo "🌱 Preparing to seed development databases..."
    echo ""
    
    # Simulate database seeding process
    databases=("users" "products" "orders" "analytics")
    
    for db in "''${databases[@]}"; do
      echo "📋 Seeding database: $db"
      echo "  🔄 Connecting to database..."
      echo "  📝 Loading schema..."
      echo "  🌱 Inserting seed data..."
      echo "  ✅ $db database seeded successfully"
      echo ""
    done
    
    echo "🎉 All databases seeded successfully!"
    echo "📊 Summary:"
    echo "  • 4 databases processed"
    echo "  • 1,247 records inserted"
    echo "  • 0 errors encountered"
    echo ""
    echo "🚀 Your development environment is ready!"
  '';
  
  scriptFile = pkgs.writeText "db-seeder-script" scriptContent;
in

pluginBuilder.buildPorterPlugin {
  name = "dbseeder";
  version = "1.0.0";
  scriptPath = scriptFile;
  description = "Porter development database seeding utility";
}

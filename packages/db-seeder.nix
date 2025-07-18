{ lib, writeShellScriptBin }:

writeShellScriptBin "db-seeder" ''
  #!/bin/sh
  echo "Seeding the development database..."
  # Real logic to connect and seed a DB would go here.
  echo "Database seeded!"
''

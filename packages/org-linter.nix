{ lib, writeShellScriptBin }:

writeShellScriptBin "org-linter" ''
  #!/bin/sh
  echo "Linting your project with the official Porter org linter..."
  # In a real scenario, you'd run your linter here.
  echo "Linting complete!"
''

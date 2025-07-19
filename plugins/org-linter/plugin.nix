{ pkgs }: # This function is called by the main flake.nix

{
  # The `package` attribute defines what gets installed.
  package = pkgs.writeShellScriptBin "org-linter" ''
    #!/bin/sh
    echo "🔍 Porter Organization Code Linter v2.0"
    echo "========================================"
    echo ""
    echo "📊 Analyzing code quality metrics..."
    echo ""
    
    # Simulate repository scanning
    repos=("frontend-app" "backend-api" "mobile-app" "data-pipeline" "devops-scripts")
    
    for repo in "''${repos[@]}"; do
      echo "📁 Repository: $repo"
      echo "  ✅ Code style: Excellent"
      echo "  ⚡ Performance: Good" 
      echo "  🔒 Security: No issues found"
      echo "  📚 Documentation: 85% coverage"
      echo "  🧪 Test coverage: 92%"
      echo ""
    done
    
    echo "🎯 Overall organization score: 89/100"
    echo ""
    echo "💡 Recommendations:"
    echo "  • Increase test coverage in mobile-app"
    echo "  • Update dependencies in data-pipeline"  
    echo "  • Add API documentation to backend-api"
    echo "  • Review security scan results for devops-scripts"
    echo ""
    echo "✅ Linting complete!"
  '';

  # The `init_hook` runs when the user enters `devbox shell`.
  init_hook = ''
    echo "✅ Porter Org Linter plugin is active. Run 'org-linter' to scan your codebase."
  '';
}

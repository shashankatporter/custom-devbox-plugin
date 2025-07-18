{
  # Central plugin registry - organized by category
  development = {
    org-linter = {
      path = "../modules/org-linter";
      versions = [ "1.0.0" ];
      description = "Organization-wide code quality and standards linter";
      category = "quality-assurance";
      maintainer = "porter-dev-team";
    };
    
    db-seeder = {
      path = "../modules/db-seeder";
      versions = [ "1.0.0" ];
      description = "Development database seeding utility";
      category = "database";
      maintainer = "porter-dev-team";
    };
  };
  
  # Future categories can be added here:
  # deployment = { ... };
  # testing = { ... };
  # monitoring = { ... };
}

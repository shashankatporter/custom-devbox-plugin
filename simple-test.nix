{
  description = "Simple test with dots";
  
  outputs = { self }: {
    packages.x86_64-darwin = {
      "test-v1.0.0" = "hello";
      test-simple = "world";
    };
  };
}

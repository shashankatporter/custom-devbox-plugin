#!/bin/bash
# test-plugin.sh - Test script for the custom devbox plugin

echo "Testing custom devbox plugin..."

# Create a temporary test directory
TEST_DIR="/tmp/devbox-plugin-test"
rm -rf "$TEST_DIR"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

echo "Created test directory: $TEST_DIR"

# Initialize a new devbox project
echo "Initializing devbox project..."
devbox init

# Try to add the plugin
echo "Adding org-linter plugin..."
devbox add "git+ssh://git@github.com/shashankatporter/custom-devbox-plugin.git#org-linter"

if [ $? -eq 0 ]; then
    echo "✅ Plugin added successfully!"
    
    # Test entering the shell
    echo "Testing devbox shell..."
    devbox shell --command "org-linter"
    
    if [ $? -eq 0 ]; then
        echo "✅ Plugin works correctly!"
    else
        echo "❌ Plugin failed to execute"
    fi
else
    echo "❌ Failed to add plugin"
fi

# Cleanup
cd - > /dev/null
echo "Test completed. Cleanup: rm -rf $TEST_DIR"

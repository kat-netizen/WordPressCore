#!/bin/bash

echo "=== Stopping WordPress Development Environment ==="

# Find and kill PHP server running on port 8080
PHP_PID=$(lsof -t -i:8080 2>/dev/null)

if [ -n "$PHP_PID" ]; then
    echo "Stopping PHP server (PID: $PHP_PID)..."
    kill $PHP_PID 2>/dev/null
    sleep 1
    
    # Force kill if still running
    if kill -0 $PHP_PID 2>/dev/null; then
        kill -9 $PHP_PID 2>/dev/null
    fi
    echo "PHP server stopped."
else
    echo "PHP server is not running."
fi

echo ""
echo "MariaDB is still running (auto-managed by devcontainer)."
echo "To stop MariaDB manually: sudo service mariadb stop"
echo ""
echo "=== WordPress stopped ==="

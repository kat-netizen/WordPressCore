#!/bin/bash

echo "=== Starting WordPress Development Environment ==="

# Ensure MariaDB is running
if ! pgrep -x "mariadbd" > /dev/null; then
    echo "Starting MariaDB..."
    sudo service mariadb start
    sleep 2
else
    echo "MariaDB is already running."
fi

# Check if PHP server is already running on port 8080
if lsof -i:8080 > /dev/null 2>&1; then
    echo ""
    echo "⚠️  Port 8080 is already in use. PHP server may already be running."
    echo "   Run 'wp-stop' or use the 'Stop WordPress' task to stop it first."
    exit 1
fi

echo ""
echo "Starting PHP development server on port 8080..."
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  WordPress is running at: http://localhost:8080"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Press Ctrl+C to stop the server."
echo ""

# Start PHP built-in server (foreground)
php -S localhost:8080 -t /workspaces/WordPressCore

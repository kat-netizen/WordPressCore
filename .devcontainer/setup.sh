#!/bin/bash
set -e

echo "=== WordPress Development Environment Setup ==="

# Install MariaDB
echo "Installing MariaDB..."
sudo apt-get update
sudo apt-get install -y mariadb-server mariadb-client

# Install PHP extensions using docker-php-ext-install (built into the PHP image)
echo "Installing PHP extensions..."
sudo docker-php-ext-install -j$(nproc) mysqli pdo_mysql

# Start MariaDB
echo "Starting MariaDB..."
sudo service mariadb start

# Wait for MariaDB to be ready
sleep 3

# Create WordPress database and user
echo "Setting up WordPress database..."
sudo mariadb -e "CREATE DATABASE IF NOT EXISTS wordpress DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
sudo mariadb -e "CREATE USER IF NOT EXISTS 'wordpress'@'localhost' IDENTIFIED BY 'wordpress';"
sudo mariadb -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'localhost';"
sudo mariadb -e "FLUSH PRIVILEGES;"

echo ""
echo "=== Setup Complete ==="
echo ""
echo "To start WordPress, run:"
echo "  php -S localhost:8080 -t /workspaces/WordPressCore"
echo ""
echo "Database credentials:"
echo "  Database: wordpress"
echo "  Username: wordpress"
echo "  Password: wordpress"
echo ""

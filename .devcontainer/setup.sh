#!/bin/bash
set -e

echo "=== WordPress LAMP Stack Setup ==="

# Install Apache and PHP extensions
echo "Installing Apache and PHP extensions..."
sudo apt-get update
sudo apt-get install -y \
    apache2 \
    libapache2-mod-php8.3 \
    php8.3-mysql \
    php8.3-xml \
    php8.3-mbstring \
    php8.3-curl \
    php8.3-gd \
    php8.3-zip \
    php8.3-intl \
    php8.3-imagick

# Enable Apache modules
echo "Enabling Apache modules..."
sudo a2enmod rewrite
sudo a2enmod php8.3

# Configure Apache to listen on port 8080
echo "Configuring Apache..."
sudo sed -i 's/Listen 80/Listen 8080/' /etc/apache2/ports.conf

# Copy custom Apache config
sudo cp /workspaces/WordPressCore/.devcontainer/apache.conf /etc/apache2/sites-available/wordpress.conf

# Disable default site and enable WordPress site
sudo a2dissite 000-default
sudo a2ensite wordpress

# Set permissions for WordPress directory
sudo chown -R www-data:www-data /workspaces/WordPressCore/wp-content
sudo chmod -R 755 /workspaces/WordPressCore/wp-content

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

# Restore database backup if it exists
if [ -f /workspaces/WordPressCore/.devcontainer/db-backup.sql ]; then
    echo "Restoring database from backup..."
    bash /workspaces/WordPressCore/.devcontainer/db-restore.sh
fi

# Start Apache
echo "Starting Apache..."
sudo service apache2 start

echo ""
echo "=== Setup Complete ==="
echo "WordPress is ready! Access it via the forwarded port 8080."
echo ""
echo "Database credentials:"
echo "  Database: wordpress"
echo "  Username: wordpress"
echo "  Password: wordpress"
echo ""
echo "To backup your database before rebuilding:"
echo "  bash .devcontainer/db-backup.sh"
echo ""

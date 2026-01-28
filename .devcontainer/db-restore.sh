#!/bin/bash
# WordPress Database Restore Script
# Restores database from backup file

set -e

BACKUP_FILE="/workspaces/WordPressCore/.devcontainer/db-backup.sql"
DATABASE="wordpress"

echo "=== WordPress Database Restore ==="

# Check if backup file exists
if [ ! -f "$BACKUP_FILE" ]; then
    echo "No backup file found at $BACKUP_FILE"
    echo "Nothing to restore."
    exit 0
fi

# Check if MariaDB is running
if ! sudo service mariadb status > /dev/null 2>&1; then
    echo "Starting MariaDB..."
    sudo service mariadb start
    sleep 2
fi

# Show backup info
SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
echo "Backup file: $BACKUP_FILE"
echo "Size: $SIZE"
echo ""

# Restore backup
echo "Restoring database '$DATABASE'..."
sudo mariadb < "$BACKUP_FILE"

echo ""
echo "=== Restore Complete ==="
echo "Database '$DATABASE' has been restored from backup."

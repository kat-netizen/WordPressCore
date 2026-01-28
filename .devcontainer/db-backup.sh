#!/bin/bash
# WordPress Database Backup Script
# Run this before rebuilding your Codespace to preserve your database

set -e

BACKUP_FILE="/workspaces/WordPressCore/.devcontainer/db-backup.sql"
DATABASE="wordpress"

echo "=== WordPress Database Backup ==="

# Check if MariaDB is running
if ! sudo service mariadb status > /dev/null 2>&1; then
    echo "Starting MariaDB..."
    sudo service mariadb start
    sleep 2
fi

# Create backup
echo "Backing up database '$DATABASE' to $BACKUP_FILE..."
sudo mariadb-dump --databases "$DATABASE" > "$BACKUP_FILE"

# Show backup info
if [ -f "$BACKUP_FILE" ]; then
    SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
    echo ""
    echo "=== Backup Complete ==="
    echo "File: $BACKUP_FILE"
    echo "Size: $SIZE"
    echo ""
    echo "This file is git-ignored. To preserve it across rebuilds:"
    echo "  1. Commit it temporarily, or"
    echo "  2. Copy it to a safe location"
    echo ""
else
    echo "ERROR: Backup file was not created!"
    exit 1
fi

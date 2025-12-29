#!/bin/bash

# Staging Rollback Script
STAGING_DIR="/var/www/staging"
BACKUP_DIR="/var/www/staging-backup"
LOG_FILE="/var/log/staging-deploy.log"

echo "$(date): Starting staging rollback" | sudo tee -a $LOG_FILE

if [ -d "$BACKUP_DIR" ]; then
    echo "$(date): Restoring staging from backup" | sudo tee -a $LOG_FILE
    sudo rm -rf $STAGING_DIR
    sudo cp -r $BACKUP_DIR $STAGING_DIR
    sudo chown -R www-data:www-data $STAGING_DIR
    sudo chmod -R 755 $STAGING_DIR
    
    # Test rollback
    sleep 2
    if curl -f http://localhost:8081 > /dev/null 2>&1; then
        echo "$(date): Staging rollback successful" | sudo tee -a $LOG_FILE
        exit 0
    else
        echo "$(date): Staging rollback failed" | sudo tee -a $LOG_FILE
        exit 1
    fi
else
    echo "$(date): No backup found for staging rollback" | sudo tee -a $LOG_FILE
    exit 1
fi

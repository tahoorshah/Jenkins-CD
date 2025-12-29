#!/bin/bash

# Production Rollback Script
PRODUCTION_DIR="/var/www/production"
BACKUP_DIR="/var/www/production-backup"
LOG_FILE="/var/log/production-deploy.log"

echo "$(date): Starting production rollback" | sudo tee -a $LOG_FILE

if [ -d "$BACKUP_DIR" ]; then
    echo "$(date): Restoring production from backup" | sudo tee -a $LOG_FILE
    sudo rm -rf $PRODUCTION_DIR
    sudo cp -r $BACKUP_DIR $PRODUCTION_DIR
    sudo chown -R www-data:www-data $PRODUCTION_DIR
    sudo chmod -R 755 $PRODUCTION_DIR
    
    # Test rollback
    sleep 2
    if curl -f http://localhost:8082 > /dev/null 2>&1; then
        echo "$(date): Production rollback successful" | sudo tee -a $LOG_FILE
        exit 0
    else
        echo "$(date): Production rollback failed" | sudo tee -a $LOG_FILE
        exit 1
    fi
else
    echo "$(date): No backup found for production rollback" | sudo tee -a $LOG_FILE
    exit 1
fi

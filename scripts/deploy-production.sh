#!/bin/bash

# Production Deployment Script
PRODUCTION_DIR="/var/www/production"
STAGING_DIR="/var/www/staging"
BACKUP_DIR="/var/www/production-backup"
LOG_FILE="/var/log/production-deploy.log"

echo "$(date): Starting production deployment" | sudo tee -a $LOG_FILE

# Create backup of current production
if [ -d "$PRODUCTION_DIR" ]; then
    echo "$(date): Creating backup of current production" | sudo tee -a $LOG_FILE
    sudo rm -rf $BACKUP_DIR
    sudo cp -r $PRODUCTION_DIR $BACKUP_DIR
fi

# Create production directory if it doesn't exist
sudo mkdir -p $PRODUCTION_DIR

# Copy from staging to production
echo "$(date): Copying application files from staging to production" | sudo tee -a $LOG_FILE
sudo cp -r $STAGING_DIR/* $PRODUCTION_DIR/

# Set proper permissions
sudo chown -R www-data:www-data $PRODUCTION_DIR
sudo chmod -R 755 $PRODUCTION_DIR

# Test deployment
if curl -f http://localhost:8082 > /dev/null 2>&1; then
    echo "$(date): Production deployment successful" | sudo tee -a $LOG_FILE
    exit 0
else
    echo "$(date): Production deployment failed - health check failed" | sudo tee -a $LOG_FILE
    exit 1
fi

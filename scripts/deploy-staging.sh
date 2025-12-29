#!/bin/bash

# Staging Deployment Script
STAGING_DIR="/var/www/staging"
APP_DIR="$HOME/cd-lab/app"
BACKUP_DIR="/var/www/staging-backup"
LOG_FILE="/var/log/staging-deploy.log"

echo "$(date): Starting staging deployment" | sudo tee -a $LOG_FILE

# Create backup of current staging
if [ -d "$STAGING_DIR" ]; then
    echo "$(date): Creating backup of current staging" | sudo tee -a $LOG_FILE
    sudo rm -rf $BACKUP_DIR
    sudo cp -r $STAGING_DIR $BACKUP_DIR
fi

# Create staging directory if it doesn't exist
sudo mkdir -p $STAGING_DIR

# Copy new application files
echo "$(date): Copying application files to staging" | sudo tee -a $LOG_FILE
sudo cp -r $APP_DIR/* $STAGING_DIR/

# Set proper permissions
sudo chown -R www-data:www-data $STAGING_DIR
sudo chmod -R 755 $STAGING_DIR

# Test deployment
if curl -f http://localhost:8081 > /dev/null 2>&1; then
    echo "$(date): Staging deployment successful" | sudo tee -a $LOG_FILE
    exit 0
else
    echo "$(date): Staging deployment failed - health check failed" | sudo tee -a $LOG_FILE
    exit 1
fi

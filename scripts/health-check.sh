#!/bin/bash

# Health Check Script
STAGING_URL="http://localhost:8081"
PRODUCTION_URL="http://localhost:8082"
LOG_FILE="/var/log/health-check.log"

check_environment() {
    local env_name=$1
    local url=$2
    
    echo "$(date): Checking $env_name environment" | tee -a $LOG_FILE
    
    # Check if service is responding
    if curl -f -s "$url/health" > /dev/null; then
        echo "$(date): $env_name health check passed" | tee -a $LOG_FILE
        return 0
    else
        echo "$(date): $env_name health check failed" | tee -a $LOG_FILE
        return 1
    fi
}

# Check staging
if ! check_environment "Staging" "$STAGING_URL"; then
    echo "Staging environment is unhealthy"
    exit 1
fi

# Check production
if ! check_environment "Production" "$PRODUCTION_URL"; then
    echo "Production environment is unhealthy"
    exit 1
fi

echo "All environments are healthy"
exit 0

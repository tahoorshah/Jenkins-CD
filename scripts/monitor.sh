#!/bin/bash

# Continuous Monitoring Script
STAGING_URL="http://localhost:8081"
PRODUCTION_URL="http://localhost:8082"
LOG_FILE="/var/log/cd-monitor.log"
CHECK_INTERVAL=30

monitor_environment() {
    local env_name=$1
    local url=$2
    
    while true; do
        if curl -f -s "$url/health" > /dev/null; then
            echo "$(date): $env_name is healthy" | tee -a $LOG_FILE
        else
            echo "$(date): $env_name is unhealthy - triggering alert" | tee -a $LOG_FILE
            # In a real scenario, this would trigger alerts/notifications
        fi
        sleep $CHECK_INTERVAL
    done
}

echo "$(date): Starting continuous monitoring" | tee -a $LOG_FILE

# Monitor both environments in parallel
monitor_environment "Staging" "$STAGING_URL" &
monitor_environment "Production" "$PRODUCTION_URL" &

wait

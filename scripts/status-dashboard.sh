#!/bin/bash

# Deployment Status Dashboard
clear
echo "=================================="
echo "   CD Pipeline Status Dashboard   "
echo "=================================="
echo

# Check Jenkins status
if systemctl is-active --quiet jenkins; then
    echo "Jenkins: RUNNING"
else
    echo "Jenkins: STOPPED"
fi

# Check Nginx status
if systemctl is-active --quiet nginx; then
    echo "Nginx: RUNNING"
else
    echo "Nginx: STOPPED"
fi

echo
echo "Environment Status:"
echo "==================="

# Check staging
if curl -f -s http://localhost:8081/health > /dev/null 2>&1; then
    echo "Staging: HEALTHY"
else
    echo "Staging: UNHEALTHY"
fi

# Check production
if curl -f -s http://localhost:8082/health > /dev/null 2>&1; then
    echo "Production: HEALTHY"
else
    echo "Production: UNHEALTHY"
fi

echo
echo "Recent Deployment Logs:"
echo "======================="
if [ -f /var/log/production-deploy.log ]; then
    tail -5 /var/log/production-deploy.log
else
    echo "No deployment logs found"
fi

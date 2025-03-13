#!/bin/bash

# Exit immediately if any command fails
set -e

# Define the expected service URL
URL="http://team${TEAM_NUMBER}.northeurope.azurecontainer.io/"

echo "Starting End-to-End Tests for $URL ..."

# Step 1: Wait for the service to be available (adjust retries if needed)
MAX_RETRIES=10
RETRY_DELAY=5

for i in $(seq 1 $MAX_RETRIES); do
  RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" "$URL")
  
  if [ "$RESPONSE" -eq 200 ]; then
    echo "E2E Test Passed! Application is running successfully at $URL"
    exit 0
  fi
  
  echo "Attempt $i/$MAX_RETRIES: Waiting for service to be available..."
  sleep $RETRY_DELAY
done

# Step 2: If max retries reached, fail the test
echo "E2E Test Failed! Application did not respond with 200 at $URL"
exit 1

#!/bin/bash

set -e
# Define API URL
API_URL="http://team${TEAM_NUMBER}.northeurope.azurecontainer.io"

# Wait for the API to be available (max 60s)
echo "Waiting for API to be live..."
for i in {1..30}; do
    if curl -s --head --request GET "$API_URL/" | grep "200 OK" > /dev/null; then
        echo "API is live!"
        break
    fi
    if [ $i -eq 30 ]; then
        echo "ERROR: API did not become available within 60 seconds!"
        exit 1
    fi
    echo "Waiting..."
    sleep 2
done

# Verify we can get actual content, not just headers
echo "Verifying API response..."
RESPONSE=$(curl -s "$API_URL/")
if [ -z "$RESPONSE" ]; then
    echo "ERROR: API returned empty response!"
    exit 1
fi

echo "API tests passed successfully!"
exit 0

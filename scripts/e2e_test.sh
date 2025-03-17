#!/bin/bash

# Exit immediately if any command fails
set -e
status_code=$(curl -s -o /dev/null -w "%{http_code}" -m 30 "http://team$TEAM_NUMBER.northeurope.azurecontainer.io/")

if [[ "$status_code" == "200" ]]; then
    echo "URL $url returned status code 200 (OK)"
else
    echo "Error: URL $url returned status code $status_code" >&2
    exit 1
fi

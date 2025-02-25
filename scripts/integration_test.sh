#!/bin/bash
set -e

PACKAGE_VERSION=$(grep -Po '(?<=^version = ")[^"]*' pyproject.toml)
CONTAINER_NAME="team${TEAM_NUMBER}_container"

docker run -d -p 80:80 --name $CONTAINER_NAME $LOGIN_SERVER/team$TEAM_NUMBER:$PACKAGE_VERSION

echo "Waiting for container to start..."
sleep 20

curl -s -o /dev/null -w "%{http_code}" http://localhost:80


if [ $? -eq 0 ]; then
    echo "Container is running"
    EXIT_CODE=0
else
    echo "Container is not running"
    EXIT_CODE=1
fi

echo "Stopping and removing container..."
docker stop $CONTAINER_NAME
docker rm $CONTAINER_NAME

exit $EXIT_CODE

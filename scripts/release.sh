#!/bin/bash
set -e

#Push the container to the registry
PACKAGE_VERSION=$(grep -Po '(?<=^version = ")[^"]*' pyproject.toml)
echo "$REGISTRY_PASSWORD" | docker login $LOGIN_SERVER -u $REGISTRY_USERNAME --password-stdin
docker push $LOGIN_SERVER/team$TEAM_NUMBER:$PACKAGE_VERSION
docker logout $LOGIN_SERVER


#Make the package version available to the next step
echo "package-version=$PACKAGE_VERSION" >> "$GITHUB_OUTPUT"
#!/bin/bash
set -e

PACKAGE_VERSION=$(grep -Po '(?<=^version = ")[^"]*' pyproject.toml)


docker build -t $LOGIN_SERVER/team$TEAM_NUMBER:$PACKAGE_VERSION .
docker tag $LOGIN_SERVER/team$TEAM_NUMBER:$PACKAGE_VERSION team$TEAM_NUMBER:latest
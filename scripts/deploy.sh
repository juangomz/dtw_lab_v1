#!/bin/bash
set -e


#Login to the Azure Cloud
az login --service-principal --username $AZURE_CLIENT_ID --password $AZURE_CLIENT_SECRET --tenant $AZURE_TENANT_ID
az account set --subscription $AZURE_SUBSCRIPTION_ID


#Tell the Azure cloud to create a container using our image.
az container create \
  --resource-group dtw \
  --name team${TEAM_NUMBER}dtw \
  --image ${LOGIN_SERVER}/team${TEAM_NUMBER}:$PACKAGE_VERSION \
  --os-type Linux \
  --memory 0.5 \
  --cpu 0.25 \
  --ip-address public \
  --dns-name-label team${TEAM_NUMBER} \
  --restart-policy Always \
  --registry-login-server ${LOGIN_SERVER} \
  --registry-username ${REGISTRY_USERNAME} \
  --registry-password ${REGISTRY_PASSWORD} \
  --ports 80

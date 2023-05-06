#!/bin/bash
gcloud api-gateway api-configs create minion-config \
  --api=minions \
  --openapi-spec=./openapi.yml 
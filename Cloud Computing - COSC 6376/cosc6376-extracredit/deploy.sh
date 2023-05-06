#!/bin/bash
gcloud functions deploy minions \
  --runtime nodejs18 \
  --trigger-http \
  --allow-unauthenticated \
  --region us-central1 
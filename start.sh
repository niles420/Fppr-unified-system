#!/bin/bash
set -e

# Pull latest changes
git pull origin main

# Build Docker images
docker build -t fppr-hive:latest -f Dockerfile.hive .
docker build -t fppr-member:latest -f Dockerfile.member .

# Apply Kubernetes configurations
kubectl apply -f fppr-hive-deployment.yaml
kubectl apply -f fppr-member-deployment.yaml
kubectl apply -f fppr-service.yaml

# Verify pods
kubectl get pods

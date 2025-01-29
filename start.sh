#!/bin/bash
set -e

# Pull the latest changes
git pull origin main

# Build and load the local Docker images
docker build -t fppr-hive:latest -f Dockerfile.hive .
docker build -t fppr-member:latest -f Dockerfile.member .

# Load images into Minikube (if applicable)
minikube image load fppr-hive:latest
minikube image load fppr-member:latest

# Apply Kubernetes configurations
kubectl apply -f fppr-hive-deployment.yaml
kubectl apply -f fppr-member-deployment.yaml

# Restart pods to use updated images
kubectl delete pod -l app=fppr-hive
kubectl delete pod -l app=fppr-member

# Display running pods
kubectl get pods

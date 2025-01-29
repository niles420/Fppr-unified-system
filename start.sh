#!/bin/bash
set -e

echo "🚀 Pulling latest changes from repository..."
git pull origin main

echo "📦 Building Docker images..."
docker build -t fppr-hive:latest -f Dockerfile.hive .
docker build -t fppr-member:latest -f Dockerfile.member .

echo "🚢 Loading images into Minikube..."
minikube image load fppr-hive:latest
minikube image load fppr-member:latest

echo "🛠 Applying Kubernetes configurations..."
kubectl apply -f fppr-hive-deployment.yaml
kubectl apply -f fppr-member-deployment.yaml

echo "📡 Exposing FPPR Hive Service..."
kubectl apply -f fppr-hive-deployment.yaml  # Ensuring service is applied
kubectl delete pod -l app=fppr-hive
kubectl delete pod -l app=fppr-member

echo "✅ Checking Service Status..."
kubectl get services

echo "🌐 Retrieving FPPR Hive URL..."
HIVE_URL=$(minikube service fppr-hive-service --url)
echo "FPPR Hive is accessible at: $HIVE_URL"

echo "🚀 FPPR Network is now running!"

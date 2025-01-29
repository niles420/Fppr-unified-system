#!/bin/bash
set -e  # Exit immediately if any command fails

# ✅ Ensure GitHub Token is Stored Securely
if [ ! -f ~/.git-credentials ]; then
  echo "🔑 Storing GitHub Token for first-time deployment..."
  GITHUB_USER="niles420"
  GITHUB_TOKEN="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"
  echo "https://$GITHUB_USER:$GITHUB_TOKEN@github.com" > ~/.git-credentials
  git config --global credential.helper store
  git config --global user.email "420niles@gmail.com"
  git config --global user.name "niles420"
  echo "✅ GitHub Token stored securely."
fi

# ✅ Set Git Remote URL with Token
GITHUB_REPO="https://niles420@github.com/niles420/fppr-unified-system.git"
git remote set-url origin $GITHUB_REPO

echo "🚀 Pulling latest changes from repository..."
git pull origin main

# ✅ Build & Load Docker Images
echo "📦 Building Docker images..."
docker build -t fppr-hive:latest -f Dockerfile.hive .
docker build -t fppr-member:latest -f Dockerfile.member .

echo "🚢 Loading images into Minikube..."
minikube image load fppr-hive:latest
minikube image load fppr-member:latest

# ✅ Apply Kubernetes Deployments
echo "🛠 Applying Kubernetes configurations..."
kubectl apply -f fppr-hive-deployment.yaml
kubectl apply -f fppr-member-deployment.yaml

echo "📡 Exposing FPPR Hive Service..."
kubectl apply -f fppr-hive-deployment.yaml  # Ensuring service is applied
kubectl delete pod -l app=fppr-hive
kubectl delete pod -l app=fppr-member

# ✅ Check Service Status
echo "✅ Checking Service Status..."
kubectl get services

# ✅ Retrieve FPPR Hive URL
echo "🌐 Retrieving FPPR Hive URL..."
HIVE_URL=$(minikube service fppr-hive-service --url)
echo "FPPR Hive is accessible at: $HIVE_URL"

echo "🚀 FPPR Network is now running!"

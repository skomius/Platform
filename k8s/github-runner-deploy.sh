#!/bin/bash

# Deploy GitHub Actions Self-Hosted Runner

echo "Deploying GitHub Actions Runner..."
kubectl apply -f github-runner-deployment.yml

echo "Waiting for runner to be ready..."
kubectl wait --for=condition=available --timeout=120s deployment/github-runner -n apps

echo ""
echo "=========================================="
echo "GitHub Runner Deployment Complete!"
echo "=========================================="
echo ""
echo "Useful commands:"
echo "  Check runner pods: kubectl get pods -n apps -l app=github-runner"
echo "  Check runner logs: kubectl logs -n apps -l app=github-runner"
echo "  Describe runner: kubectl describe deployment github-runner -n apps"
echo ""
echo "Note: Make sure you have configured the GitHub token/PAT in the deployment manifest"
echo ""

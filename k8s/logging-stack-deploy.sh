#!/bin/bash

# Deploy Fluent Bit + Elasticsearch + Grafana Logging Stack

echo "Deploying Elasticsearch..."
kubectl apply -f elasticsearch-deployment.yml

echo "Waiting for Elasticsearch to be ready..."
kubectl wait --for=condition=available --timeout=180s deployment/elasticsearch -n apps

echo "Deploying Fluent Bit..."
kubectl apply -f fluent-bit-daemonset.yml

echo "Deploying Grafana..."
kubectl apply -f grafana-deployment.yml

echo "Waiting for Grafana to be ready..."
kubectl wait --for=condition=available --timeout=120s deployment/grafana -n apps

echo ""
echo "=========================================="
echo "Logging Stack Deployment Complete!"
echo "=========================================="
echo ""
echo "Access Grafana at: http://<node-ip>:30300"
echo "Default credentials:"
echo "  Username: admin"
echo "  Password: admin"
echo ""
echo "Elasticsearch is configured as the default data source."
echo ""
echo "Useful commands:"
echo "  Check Fluent Bit pods: kubectl get pods -n apps -l app=fluent-bit"
echo "  Check Elasticsearch logs: kubectl logs -n apps -l app=elasticsearch"
echo "  Check Grafana logs: kubectl logs -n apps -l app=grafana"
echo "  Port-forward Grafana: kubectl port-forward -n apps svc/grafana 3000:3000"
echo "  Port-forward Elasticsearch: kubectl port-forward -n apps svc/elasticsearch 9200:9200"
echo ""

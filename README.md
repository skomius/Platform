# Platform Infrastructure

Kubernetes infrastructure and platform services for application deployment and monitoring.

## Overview

This repository contains all platform and infrastructure configurations for deploying and managing applications on Kubernetes, including:
- Kubernetes manifests for application deployments
- Logging stack (Fluent Bit + Loki + Grafana)
- Monitoring and observability tools
- GitHub Actions runners for CI/CD
- Database and storage configurations

## Prerequisites

- Kubernetes cluster (Minikube, EKS, GKE, AKS, etc.)
- kubectl configured
- Docker (for building images)
- Helm (optional, for package management)

## Components

### Application Deployment
- **Location**: `k8s/app-deployment.yml`
- Deploy applications to the Kubernetes cluster

### Logging Stack
- **Fluent Bit**: Log collection and forwarding
- **Loki**: Log aggregation and storage
- **Grafana**: Visualization and dashboards
- **Deploy**: `./k8s/logging-stack-deploy.sh`

### GitHub Actions Runner
- Self-hosted runner for CI/CD pipelines
- **Location**: `k8s/github-runner-deployment.yml`

### PostgreSQL Backup
- Automated database backup CronJob
- **Location**: `k8s/postgres-backup-cronjob.yml`

### Elasticsearch
- **Location**: `k8s/elasticsearch-deployment.yml`

## Quick Start

### Deploy Logging Stack
```bash
cd k8s
./logging-stack-deploy.sh
```

Access Grafana at `http://<node-ip>:30300` (default credentials: admin/admin)

### Deploy Application
```bash
kubectl apply -f k8s/app-deployment.yml
```

### Deploy GitHub Runner
```bash
kubectl apply -f k8s/github-runner-deployment.yml
```

## Monitoring and Observability

### Grafana Access
- URL: `http://<node-ip>:30300`
- Default credentials: admin/admin
- Loki is pre-configured as a data source

### Useful Commands
```bash
# Check all pods
kubectl get pods -n apps

# Check Fluent Bit logs
kubectl logs -n apps -l app=fluent-bit

# Check Loki logs
kubectl logs -n apps -l app=loki

# Check Grafana logs
kubectl logs -n apps -l app=grafana

# Port-forward Grafana locally
kubectl port-forward -n apps svc/grafana 3000:3000
```

## Configuration

### Image Registries
Update image references in deployment manifests to point to your container registry.

### Secrets Management
Set up Kubernetes secrets for sensitive data:
```bash
kubectl create secret generic <secret-name> --from-literal=key=value
```

## Directory Structure
```
k8s/
├── app-deployment.yml           # Application deployment manifest
├── elasticsearch-deployment.yml # Elasticsearch deployment
├── fluent-bit-daemonset.yml    # Log collection agent
├── grafana-deployment.yml       # Grafana monitoring
├── github-runner-deployment.yml # CI/CD runner
├── postgres-backup-cronjob.yml  # Database backup automation
└── logging-stack-deploy.sh      # Logging stack deployment script
```

## Application Migration

The Spring Boot application has been moved to a separate repository for better separation of concerns.
- Application code: See `springboot-app-export/` directory (ready to be moved to a new repository)
- This repository focuses on platform infrastructure and deployment configurations

## Contributing

When adding new infrastructure components:
1. Add manifests to the `k8s/` directory
2. Update this README with deployment instructions
3. Include monitoring and logging configurations
4. Document any required secrets or configuration
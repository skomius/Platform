# Platform Infrastructure

Kubernetes platform infrastructure for running applications on Minikube with centralized logging and CI/CD capabilities.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Minikube Installation](#minikube-installation)
- [GitHub Runner Setup](#github-runner-setup)
- [Logging Stack Deployment](#logging-stack-deployment)
- [Infrastructure Management](#infrastructure-management)

## Prerequisites

- Windows 10/11
- Administrative privileges
- At least 4GB RAM available for Minikube
- 20GB free disk space

## Minikube Installation

### Step 1: Install Docker Desktop

```powershell
# Option 1: Using winget
winget install Docker.DockerDesktop

# Option 2: Download and install manually
# Visit https://www.docker.com/products/docker-desktop and download Docker Desktop for Windows
```

**After installation:**
1. Start Docker Desktop from Start Menu
2. Wait for Docker to complete startup (whale icon in system tray should be green)
3. Verify Docker is running:

```powershell
docker --version
docker ps
```

### Step 2: Install kubectl

```powershell
# Option 1: Using Chocolatey (recommended)
choco install kubernetes-cli

# Option 2: Using winget
winget install Kubernetes.kubectl

# Option 3: Using PowerShell direct download
curl.exe -LO "https://dl.k8s.io/release/v1.28.0/bin/windows/amd64/kubectl.exe"
# Then move kubectl.exe to a directory in your PATH

# Verify installation
kubectl version --client
```

### Step 3: Install Minikube

```powershell
# Option 1: Using Chocolatey (recommended)
choco install minikube

# Option 2: Using winget
winget install Kubernetes.minikube

# Option 3: Download installer manually
# Visit https://storage.googleapis.com/minikube/releases/latest/minikube-installer.exe
# Run the installer

# Verify installation
minikube version
```

### Step 4: Start Minikube

```powershell
# Start Minikube with Docker driver
minikube start --driver=docker --cpus=2 --memory=4096

# Verify cluster is running
kubectl cluster-info
kubectl get nodes

# Enable metrics-server (optional, for resource monitoring)
minikube addons enable metrics-server
```

### Step 5: Create Namespace

```powershell
# Create apps namespace for deployments
kubectl create namespace apps
```

## GitHub Runner Setup

### Step 1: Generate GitHub Personal Access Token (PAT)

1. Go to GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Click "Generate new token (classic)"
3. Set note: `Minikube Self-Hosted Runner`
4. Select scopes:
   - `repo` (Full control of private repositories)
   - `workflow` (Update GitHub Action workflows)
   - `admin:org` (if using organization runner)
5. Click "Generate token"
6. **Copy the token immediately** (you won't see it again)

### Step 2: Update GitHub Runner Deployment to local minikube

Edit `k8s/github-runner-deployment.yml` and update the secret values:

```powershell
# Encode your GitHub token
$token = "YOUR_GITHUB_TOKEN"
$tokenBytes = [System.Text.Encoding]::UTF8.GetBytes($token)
$tokenEncoded = [Convert]::ToBase64String($tokenBytes)
Write-Host "Encoded token: $tokenEncoded"

# Encode your repository URL
$repoUrl = "https://github.com/YOUR_USERNAME/YOUR_REPO"
$repoBytes = [System.Text.Encoding]::UTF8.GetBytes($repoUrl)
$repoEncoded = [Convert]::ToBase64String($repoBytes)
Write-Host "Encoded repo URL: $repoEncoded"
```

Replace the values in the Secret section:
- `github_token`: Your base64-encoded PAT
- `github_repo_url`: Your base64-encoded repository URL

### Step 3: Deploy GitHub Runner

```powershell
# Navigate to k8s directory
cd k8s

# Deploy runner
kubectl apply -f github-runner-deployment.yml

# Or use the deployment script (requires Git Bash or WSL)
# bash github-runner-deploy.sh
```

### Step 4: Verify Runner Registration

```powershell
# Check runner pod status
kubectl get pods -n apps -l app=github-runner

# View runner logs
kubectl logs -n apps -l app=github-runner -f

# Go to GitHub repository → Settings → Actions → Runners
# You should see your self-hosted runner listed as "Idle" or "Active"
```

## Logging Stack

Deploying thru github workflows deploy.yml
The logging stack consists of:
- **Elasticsearch**: Log storage and indexing
- **Fluent Bit**: Log collection from all pods
- **Grafana**: Visualization and dashboards

### Access Grafana

```powershell
# Option 1: Use minikube service to get the URL
minikube service grafana -n apps --url

# Option 2: Port-forward to localhost
kubectl port-forward -n apps svc/grafana 3000:3000
# Then access at http://localhost:3000
```

**Login credentials:**
- Username: `admin`
- Password: `admin`

### Configure Elasticsearch Data Source in Grafana

1. Login to Grafana
2. Go to Configuration → Data Sources → Add data source
3. Select "Elasticsearch"
4. Configure:
   - URL: `http://elasticsearch:9200`
   - Index name: `fluent-bit` or pattern `fluent-bit-*`
   - Time field: `@timestamp`
5. Click "Save & Test"

### View Logs

```powershell
# Check Fluent Bit is collecting logs
kubectl get pods -n apps -l app=fluent-bit

# View Fluent Bit logs
kubectl logs -n apps -l app=fluent-bit

# Check Elasticsearch has data
kubectl port-forward -n apps svc/elasticsearch 9200:9200
# In another PowerShell window:
curl http://localhost:9200/_cat/indices?v
```

## Infrastructure Management

### Useful Commands

```powershell
# Check all deployments
kubectl get deployments -n apps

# Check all pods
kubectl get pods -n apps

# Check all services
kubectl get services -n apps

# View pod logs
kubectl logs -n apps <pod-name>

# Describe pod for troubleshooting
kubectl describe pod -n apps <pod-name>

# Restart a deployment
kubectl rollout restart deployment/<deployment-name> -n apps

# Delete a deployment
kubectl delete deployment <deployment-name> -n apps

# Access Minikube dashboard
minikube dashboard
```

### Stopping and Starting Minikube

```powershell
# Stop Minikube (preserves cluster state)
minikube stop

# Start Minikube again
minikube start

# Delete Minikube cluster (removes everything)
minikube delete
```

### Troubleshooting

**Pods not starting:**
```powershell
kubectl describe pod -n apps <pod-name>
kubectl logs -n apps <pod-name>
```

**Service not accessible:**
```powershell
# Check service endpoints
kubectl get endpoints -n apps

# Use minikube tunnel for LoadBalancer services (run in separate PowerShell window)
minikube tunnel
```

**Runner not registering:**
```powershell
# Check if secret exists
kubectl get secret github-runner-secret -n apps

# Check runner logs
kubectl logs -n apps -l app=github-runner

# Verify token has correct permissions
```

**Docker Desktop not starting:**
- Ensure Hyper-V or WSL2 is enabled in Windows Features
- Restart Docker Desktop
- Check Docker Desktop logs in the system tray icon

## Directory Structure

```
k8s/
├── elasticsearch-deployment.yml    # Elasticsearch for log storage
├── fluent-bit-daemonset.yml       # Log collection from all pods
├── grafana-deployment.yml          # Grafana visualization
├── github-runner-deployment.yml    # Self-hosted GitHub Actions runner
├── logging-stack-deploy.sh         # Script to deploy logging stack
└── github-runner-deploy.sh         # Script to deploy GitHub runner
```

## Next Steps

1. Deploy your applications to the `apps` namespace
2. Configure Grafana dashboards for monitoring
3. Set up alerts in Grafana
4. Configure CI/CD pipelines using the GitHub runner
5. Add application-specific infrastructure as needed

## Contributing

When adding new infrastructure:
1. Add manifests to `k8s/` directory
2. Update this README with deployment instructions
3. Test deployment on fresh Minikube cluster
4. Document any secrets or configuration requirements
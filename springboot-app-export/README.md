# Spring Boot Demo Application

A simple Spring Boot application with Gradle, containerized and ready for deployment to Kubernetes.

## Prerequisites
- JDK 21
- Gradle
- Docker
- Kubernetes cluster (Minikube, EKS, GKE, etc.)

## Local Development

### Build and Run
```bash
# Build the application
./gradlew build

# Run locally
./gradlew bootRun

# Test the endpoint
curl http://localhost:8080/
```

### Docker Build
```bash
# Build the Docker image
docker build -t springboot-demo:latest .

# Run the container
docker run -p 8080:8080 springboot-demo:latest
```

## Deployment to Kubernetes

The application can be deployed using the platform's Kubernetes manifests:
- See the Platform repository for deployment configurations
- Update the image reference in the deployment manifest
- Apply the deployment: `kubectl apply -f deployment.yml`

## Configuration

### Application Properties
Configuration is managed in `src/main/resources/application.properties`

### Environment Variables
- `SERVER_PORT`: Application port (default: 8080)

## API Endpoints

- `GET /` - Health check endpoint returning a greeting message

## Technology Stack
- Spring Boot 3.2.0
- Java 21
- Gradle
- SLF4J for logging

## Building for Production

```bash
# Create production build
./gradlew clean build

# The JAR file will be in build/libs/
```

## Docker Registry

Update the image name in:
- `Dockerfile` - base image and configuration
- Kubernetes deployment manifests
- CI/CD pipeline configuration

## Next Steps

1. Set up CI/CD pipeline (GitHub Actions, GitLab CI, Jenkins, etc.)
2. Configure Kubernetes manifests for your environment
3. Set up monitoring and logging integration
4. Add database connectivity if needed

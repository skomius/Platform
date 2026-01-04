# Spring Boot Demo App

A simple Spring Boot application with Gradle, containerized and deployable to Minikube via GitHub Actions.

## Prerequisites
- JDK 17
- Gradle
- Docker
- Minikube with GitHub Actions runner deployed (see k8s/github-runner-deployment.yml)

## Local Development
1. Build: `./gradlew build`
2. Run: `./gradlew bootRun`
3. Test: 
   - `curl http://localhost:8080/` (returns "Hello...")
   - `curl -X POST http://localhost:8080/users -H "Content-Type: application/json" -d '{"name":"John","email":"john@example.com"}'`
   - `curl http://localhost:8080/users` (lists users)

## Deployment
1. Push to GitHub main branch or trigger manually.
2. The CI/CD pipeline builds the image, pushes to your registry, and deploys to Minikube.
3. Access: `minikube service springboot-service --url`

## Configuration
- Update image registry in Dockerfile, app-deployment.yml, and deploy.yml.
- Set DOCKER_USERNAME and DOCKER_PASSWORD in GitHub Secrets.
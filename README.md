# CI/CD Pipeline for Java Applications

![Java CI/CD](https://img.shields.io/badge/Java-CI/CD-blue.svg)

## Overview

This project provides a comprehensive end-to-end Continuous Integration and Continuous Deployment (CI/CD) pipeline for Java applications. Leveraging Jenkins, Maven, Docker, and Kubernetes, this pipeline automates the build, test, and deployment processes, ensuring high-quality software delivery.

## Features

### Continuous Integration (CI)

- **Dynamic CI Pipeline**: A dynamic Jenkins pipeline that uses Docker containers as cloud agents.
  - **Container Management**: Whenever the pipeline starts, a new Docker container is created for the build process. Once the pipeline job is completed, the container is automatically removed, ensuring a clean environment for each build.
- **Maven**: Utilizes Maven for compiling, testing, and packaging Java applications.
- **SonarQube**: Integrated for code quality analysis and metrics.
- **Nexus Repository**: Artifacts are pushed to a Nexus repository for versioning and storage.
- **Docker Image Building**: Builds Docker images for the application as part of the CI process.
- **Image Scanning**: Scans the built Docker images using Trivy for vulnerabilities before deployment.
- **Email Notifications**: Integrates with SMTP to send email notifications regarding the pipeline status (success or failure).

### Continuous Deployment (CD)

- **Infrastructure Provisioning**: Uses Ansible for provisioning infrastructure and configuring a Kubernetes cluster.
- **Kubernetes Deployment Files**: Automatically creates Kubernetes deployment files for the application.
- **Deployment to Docker Hub**: Pushes Docker images to Docker Hub for accessibility.

### Monitoring

- **Prometheus & Grafana**: Integrated for monitoring server resources such as CPU, memory, and RAM.
- **Node Exporter**: Collects metrics from the server.
- **Blackbox Exporter**: Monitors website traffic and uptime.

## Architecture



# CI/CD Pipeline for Java Applications

![Java CI/CD](https://img.shields.io/badge/Java-CI/CD-blue.svg)

## Overview

This project provides a comprehensive end-to-end Continuous Integration and Continuous Deployment (CI/CD) pipeline for Java applications. Leveraging Jenkins, Maven, Docker, Kubernetes, prometheus and Grafana this pipeline automates the build, test, deployment and monitoring processes, ensuring high-quality software delivery.

### Continuous Integration (CI)

- **Dynamic CI Pipeline**: A dynamic Jenkins pipeline that uses Docker containers as cloud agents.
  - **Container Management**: Whenever the pipeline starts, a new Docker container is created for the build process. Once the pipeline job is completed, the container is automatically removed, ensuring a clean environment for each build.
- **Maven**: Utilizes Maven for compiling, testing, and packaging Java applications.
- **SonarQube**: Integrated for code quality analysis and metrics.
- **Nexus Repository**: Artifacts are pushed to a Nexus repository for versioning and storage.
- **Docker Image Building**: Builds Docker images for the application as part of the CI process.
- **Image Scanning**: Scans the built Docker images using Trivy for vulnerabilities before deployment.
- **Push Image to Docker Hub**: Pushes Docker images to Docker Hub for accessibility.
- **Email Notifications**: Integrates with SMTP to send email notifications regarding the pipeline status (success or failure).

### Continuous Deployment (CD)

- **Infrastructure Provisioning**: Uses Ansible for provisioning infrastructure and configuring a Kubernetes cluster.
- **Kubernetes Deployment Files**: Automatically creates Kubernetes deployment files for the application.

### Monitoring

- **Prometheus & Grafana**: Integrated for monitoring server resources such as CPU, memory, and RAM.
- **Node Exporter**: Collects metrics from the server.
- **Blackbox Exporter**: Monitors website traffic and uptime.

## Architecture

## Prerequisites

- **Java**: JDK installed (version >= 8).
- **Maven**: Installed for building Java applications.
- **Jenkins**: Installed with necessary plugins:
  - Docker Pipeline
  - Maven Integration
  - Email Extension Plugin
  - SonarQube Scanner
- **Nexus Repository**: Set up for artifact storage.
- **Docker**: Installed and running.
- **Kubernetes**: Access to a Kubernetes cluster.
- **Ansible**: Installed for configuration management.
- **SMTP Server**: For sending email notifications.
- **Trivy**: Installed for scanning Docker images.

## Getting Started

### Infrastructure Setup Guide

To deploy the Java application, you need to set up the necessary infrastructure. Follow these steps:

1. **Create a VPC**

- Log in to your cloud provider (e.g., AWS, GCP).
- Create a new Virtual Private Cloud (VPC) to isolate your resources.

2. **Launch EC2 Instances**

- Within the VPC, launch EC2 instances for your Jenkins, SonarQube, and Nexus servers.
- Ensure the instances have the required security groups and IAM roles attached.

3. **Set Up Jenkins Server**

- Install Jenkins on one of the EC2 instances.
- Configure Jenkins with necessary plugins and security settings.

4. **Set Up SonarQube Server**

- Deploy a SonarQube server on a separate EC2 instance.
- Configure database connections and necessary plugins for analysis.

5. **Set Up Nexus Repository Server**

- Launch another EC2 instance for Nexus.
- Configure Nexus for storing and managing your build artifacts.

6. **Create an EKS Cluster or Configure Your Own Kubernetes Cluster**

- **If using EKS:**
  - Use the AWS Management Console or CLI to create an EKS cluster.
- **If configuring your own Kubernetes cluster:**
  - Follow the necessary steps to install and configure Kubernetes on your chosen infrastructure.
  - Ensure `kubectl` is configured to interact with your cluster.

### CI/CD Pipeline Setup Guide

1. **Clone the Repository**

```bash
git clone https://github.com/Vikas-Prince/JavaApplicationDeployment
cd JavaApplicationDeployment
```

2. **Configure Jenkins**

- **Install Plugins**: Make sure to install the required Jenkins plugins listed in the prerequisites.
- **Create a Pipeline Job as Maven Project**:
- Set the pipeline to use the `Jenkinsfile` present in the repository.

3. **Configure Maven**

- Ensure your `pom.xml` file is correctly configured for building and testing your application, including SonarQube and other necessary plugins.

4. **Set Up Nexus Repository**

- Update your `pom.xml` to include the Nexus repository configuration for artifact storage.

5. **Configure Docker**

- Create a `Dockerfile` for your Java application.
- Set up Docker Hub credentials in Jenkins for image pushing.

6. **Deploy Kubernetes**

- Use the provided Ansible playbooks to provision your Kubernetes infrastructure.
- Configure Kubernetes deployment files as required.

7. **Set Up Monitoring**

- Install Prometheus and Grafana on your Kubernetes cluster.
- Configure Node Exporter and Blackbox Exporter for collecting metrics.

8. **Run the Pipeline**

- Trigger the Jenkins pipeline to start the CI/CD process.
- Monitor the status through email notifications and the Jenkins dashboard.

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request with your changes.

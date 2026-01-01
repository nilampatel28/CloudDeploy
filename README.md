# AWS EC2 Deployment with Terraform & Docker 

This repository contains everything you need to deploy a modern Node.js application to an AWS EC2 instance using Terraform for infrastructure as code and Docker for containerization.

## 📁 Repository Structure

- **/app**: The Node.js application (Express, Premium UI).
  - `Dockerfile`: Multi-stage build for the app.
  - `public/`: Modern glassmorphism frontend.
- **/terraform**: Infrastructure configuration files.
  - `main.tf`: Provider settings and Terraform requirements.
  - `ec2.tf`: EC2 instance, Security Groups, and Key Pair definitions.
  - `variable.tf`: Reusable variables for the infrastructure.
  - `outputs.tf`: Important output data (like Public IP).

## 🛠️ Prerequisites

Before you begin, ensure you have the following installed:
- [Terraform](https://developer.hashicorp.com/terraform/downloads) (v1.4+)
- [AWS CLI](https://aws.amazon.com/cli/) configured with your credentials
- [Docker](https://www.docker.com/products/docker-desktop) (for local testing)

## 🚀 Deployment Steps

### 1. Application Setup
The app is located in the `/app` directory. You can test it locally:
```bash
cd app
npm install
npm start
```

### 2. Infrastructure Setup
Navigate to the `/terraform` directory and initialize the project:
```bash
cd terraform
terraform init
```

Generate an SSH key pair for the instance:
```bash
ssh-keygen -f clouddeploy-key
```

### 3. Deploy to AWS
Verify the changes and apply the configuration:
```bash
terraform plan
terraform apply
```

### 4. Access the App
Once the deployment is complete, Terraform will output the **Instance Public IP**. Access your app in the browser at:
`http://<INSTANCE_PUBLIC_IP>:3000`

## 📺 YouTube Tutorial
This project was built as part of a guide on how to automate cloud deployments. Check out the full video for a step-by-step walkthrough!

## 📄 License
MIT License. Feel free to use this for your own projects!

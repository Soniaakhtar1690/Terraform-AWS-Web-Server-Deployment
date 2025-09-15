# Terraform-AWS-Web-Server-Deployment
Automated AWS Infrastructure Deployment with Terraform and Flask App
Project Overview

This project demonstrates automated deployment of AWS infrastructure using Terraform, including the provisioning of an EC2 instance running a Python Flask web application.

The infrastructure includes:

VPC & Subnet: Public network environment with controlled CIDR.

Security Group: SSH (22) and HTTP (80) access.

Internet Gateway & Route Table: Public internet connectivity.

EC2 Instance: Ubuntu server hosting a Flask app.

Key Pair: Secure SSH access.

Provisioners: file and remote-exec provisioners to automate app deployment.

This project highlights infrastructure as code (IaC), AWS networking, and automated application deployment.

Architecture Diagram
<img width="3638" height="1688" alt="Blank diagram" src="https://github.com/user-attachments/assets/4113033c-b81f-415d-898e-542d3cf9f82d" />

Technologies Used

Terraform – Infrastructure as Code (IaC)

AWS Services: VPC, Subnet, Internet Gateway, Route Table, Security Group, EC2, Key Pair

Python & Flask – Sample web application

Provisioners: file and remote-exec

Prerequisites

Terraform installed (Install Terraform
)

AWS account with IAM permissions

SSH key pair (id_rsa and id_rsa.pub)

Python Flask app (app.py)

Key Takeaways

Automated AWS infrastructure provisioning using Terraform

Deploying a Flask web application on EC2 automatically

Configuring VPC, subnet, security group, and routing

Using Terraform provisioners (file and remote-exec)

![Screenshot 2025-09-15 142740](https://github.com/user-attachments/assets/0f660831-5b0d-435a-b6a3-22d6ae23ad0e)
![Screenshot 2025-09-15 145111](https://github.com/user-attachments/assets/838625dd-fbfc-4762-aa82-c3fccee299f3)

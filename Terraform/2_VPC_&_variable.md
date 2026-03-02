# 📘 Terraform VPC Infrastructure Deployment Guide

## 🎯 Overview
This Terraform configuration deploys a complete AWS network infrastructure with a public web server, including VPC, subnet, internet gateway, routing, security groups, and an EC2 instance running nginx.

## 🏗️ Architecture Overview

```mermaid
flowchart TD
[ Provider ] 
      │
      ▼
[ Data Source: aws_vpc ]  ───────────┐
(Fetches existing VPC ID)             │
      │                               │
      ▼                               │
[ Resource: aws_security_group ] <────┘ (Needs VPC ID)
      │
      ▼
[ Resource: aws_instance ] <───────────┐
(Needs Security Group ID)              │
      │                                 │
      ▼                                 │
[ Variables: image_id, type, etc. ] ────┘ (Provides config details)
      │
      ▼
[ Output: public_ip ]
(Reads final result)

```

## 📋 Prerequisites

1. **AWS Account** with appropriate permissions
2. **Terraform installed** (v1.0+ recommended)
3. **AWS CLI configured** with credentials
4. **Existing SSH Key Pair** in your AWS account
5. **AWS AMI ID** for your region (default provided for us-east-1)

## 🚀 Quick Start

### Step 1: Clone and Navigate
```bash
cd Terraform/code/day-2
```

### Step 2: Create terraform.tfvars
Create a file named `terraform.tfvars` with your specific values:
```hcl
region          = "us-east-1"
vpc_cidr        = "10.0.0.0/16"
subnet_cidr     = "10.0.1.0/24"
availability_zone = "us-east-1a"
key             = "your-existing-key-pair-name"
```

### Step 3: Initialize Terraform
```bash
terraform init
```

### Step 4: Plan Deployment
```bash
terraform plan
```

### Step 5: Deploy Infrastructure
```bash
terraform apply
terraform apply -auto-approve
```

## 🧹 Cleanup

To remove all created resources:
```bash
terraform destroy
terraform destroy -auto-approve
```

### Step 6: Access Your Web Server
After deployment, Terraform will output the public IP. Access it in your browser:
```
http://<PUBLIC_IP>
```


```

### 2. Clean Up output.tf

Replace the entire `output.tf` with this clean version:

```hcl
# Output the public IP of the EC2 instance
output "public_ip" {
  description = "Public IP address of the web server"
  value       = aws_instance.TF-instance.public_ip
}

# Output the VPC ID
output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.tf_vpc.id
}

# Output the Subnet ID
output "subnet_id" {
  description = "ID of the created subnet"
  value       = aws_subnet.tf_subnet.id
}

# Output the Security Group ID
output "security_group_id" {
  description = "ID of the created security group"
  value       = aws_security_group.vpc_sg_tf.id
}
```

### 3. Improve variable.tf

Update `variable.tf` with proper validation and descriptions:

```hcl
variable "region" {
  description = "AWS region where resources will be created"
  type        = string
  validation {
    condition     = can(regex("^us-[a-z]+-[1-9]$", var.region))
    error_message = "Region must be a valid AWS region format (e.g., us-east-1)."
  }
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "VPC CIDR must be a valid IPv4 CIDR block."
  }
}

variable "subnet_cidr" {
  description = "CIDR block for the subnet (must be within VPC CIDR)"
  type        = string
  validation {
    condition     = can(cidrhost(var.subnet_cidr, 0))
    error_message = "Subnet CIDR must be a valid IPv4 CIDR block."
  }
}

variable "availability_zone" {
  description = "Availability zone for the subnet"
  type        = string
}

variable "ami" {
  description = "AMI ID for the EC2 instance (default: Amazon Linux 2023 in us-east-1)"
  type        = string
  default     = "ami-0938a60d87953e820"
  
  validation {
    condition     = length(var.ami) > 0
    error_message = "AMI ID cannot be empty."
  }
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
  
  validation {
    condition     = can(regex("^[a-z]+[0-9]+\\.[a-z]+$", var.instance_type))
    error_message = "Instance type must be a valid AWS instance type (e.g., t3.micro)."
  }
}

variable "key" {
  description = "Name of an existing AWS key pair for SSH access"
  type        = string
  validation {
    condition     = length(var.key) > 0
    error_message = "Key pair name cannot be empty."
  }
}
```

### 4. Enhance main.tf with Comments

Improve `main.tf` with better organization and comments:

```hcl
# ----------------------------------------------------------------------
# Provider Configuration
# ----------------------------------------------------------------------
provider "aws" {
  region = var.region
}

# ----------------------------------------------------------------------
# VPC Resources
# ----------------------------------------------------------------------
resource "aws_vpc" "tf_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  
  tags = {
    Name        = "tf-vpc"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

resource "aws_subnet" "tf_subnet" {
  vpc_id                  = aws_vpc.tf_vpc.id
  cidr_block              = var.subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true
  
  tags = {
    Name        = "tf-subnet"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

# ----------------------------------------------------------------------
# Networking Resources
# ----------------------------------------------------------------------
resource "aws_internet_gateway" "tf_igw" {
  vpc_id = aws_vpc.tf_vpc.id
  
  tags = {
    Name        = "tf-igw"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.tf_vpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf_igw.id
  }
  
  tags = {
    Name        = "tf-route-table"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

resource "aws_route_table_association" "rt_association" {
  subnet_id      = aws_subnet.tf_subnet.id
  route_table_id = aws_route_table.route_table.id
}

# ----------------------------------------------------------------------
# Security Resources
# ----------------------------------------------------------------------
resource "aws_security_group" "vpc_sg_tf" {
  name        = "vpc-sg-tf"
  description = "Security group for Terraform web server"
  vpc_id      = aws_vpc.tf_vpc.id
  
  tags = {
    Name        = "tf-security-group"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
  
  # SSH access (restricted - should be limited to specific IP in production)
  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # ⚠️ Restrict this in production!
  }
  
  # HTTP access
  ingress {
    description = "HTTP access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # Outbound traffic
  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ----------------------------------------------------------------------
# Compute Resources
# ----------------------------------------------------------------------
resource "aws_instance" "TF-instance" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key
  
  # Network configuration
  subnet_id                   = aws_subnet.tf_subnet.id
  vpc_security_group_ids      = [aws_security_group.vpc_sg_tf.id]
  associate_public_ip_address = true
  
  # Ensure instance is created after networking is ready
  depends_on = [
    aws_internet_gateway.tf_igw,
    aws_route_table_association.rt_association
  ]
  
  # User data script to install and configure nginx
  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install -y nginx
              systemctl enable nginx
              systemctl start nginx
              echo "<h1>Terraform NGINX Working - Deployed on $(date)</h1>" > /usr/share/nginx/html/index.html
              EOF
  
  tags = {
    Name        = "my-terraform-instance"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}
```

### 5. Create terraform.tfvars.example

Add a new file `terraform.tfvars.example` to guide users:

```hcl
# AWS Configuration
region          = "us-east-1"
availability_zone = "us-east-1a"

# Network Configuration
vpc_cidr        = "10.0.0.0/16"
subnet_cidr     = "10.0.1.0/24"

# EC2 Configuration
ami             = "ami-0938a60d87953e820" # Amazon Linux 2023 in us-east-1
instance_type   = "t3.micro"
key             = "your-existing-key-pair-name"
```

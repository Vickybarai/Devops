Here is the **complete, working code** structured into the module and root directories. This implements the "4 Pillars" strategy with the critical `timeouts` and `depends_on` configurations.

You can copy this directly into your files to match the structure of the repository you referenced.

---

## 1. Module Code: `modules/eks/`

Create a folder named `modules/eks` and create these three files inside it.

### File: `modules/eks/variables.tf`
Defines the inputs for the module.

```hcl
variable "cluster_name" {
  description = "Name of the EKS Cluster"
  type        = string
  default     = "my-eks-cluster"
}

variable "vpc_id" {
  description = "ID of the VPC where EKS will be deployed"
  type        = string
}

variable "subnet_ids" {
  description = "List of Subnet IDs where EKS nodes will be launched"
  type        = list(string)
}

variable "instance_type" {
  description = "EC2 Instance type for the worker nodes"
  type        = string
  default     = "t3.small"
}

variable "cluster_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.29"
}

variable "node_group_name" {
  description = "Name of the EKS Node Group"
  type        = string
  default     = "my-node-group"
}
```

### File: `modules/eks/main.tf`
Contains the logic for the 4 Pillars, IAM roles, and dependencies.

```hcl
# ---------------------------------------------------
# PILLAR 1: CLUSTER IAM ROLE
# ---------------------------------------------------
resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.cluster_name}-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })

  tags = {
    Name = "${var.cluster_name}-cluster-role"
  }
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

# ---------------------------------------------------
# PILLAR 2: EKS CLUSTER (Control Plane)
# ---------------------------------------------------
resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = var.cluster_version

  vpc_config {
    subnet_ids = var.subnet_ids
    # Enable public access endpoint so we can connect from local machine
    endpoint_public_access = true 
  }

  # CRITICAL: Cluster creation can take 15-20 mins. Default is 10.
  timeouts {
    create = "20m"
    delete = "20m"
  }

  # CRITICAL: Ensure policy is attached before cluster starts
  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy
  ]

  tags = {
    Name = var.cluster_name
  }
}

# ---------------------------------------------------
# PILLAR 3: NODE IAM ROLE
# ---------------------------------------------------
resource "aws_iam_role" "eks_node_role" {
  name = "${var.cluster_name}-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })

  tags = {
    Name = "${var.cluster_name}-node-role"
  }
}

# Attach the 3 Required Policies for Worker Nodes
resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_ecr_readonly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_role.name
}

# ---------------------------------------------------
# PILLAR 4: EKS NODE GROUP (Workers)
# ---------------------------------------------------
resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  instance_types = [var.instance_type]

  # CRITICAL: Ensure policies are attached before nodes boot
  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.eks_ecr_readonly,
    # Ensure cluster exists before adding nodes
    aws_eks_cluster.this
  ]

  labels = {
    environment = "dev"
  }

  tags = {
    Name = "${var.cluster_name}-node-group"
  }
}
```

### File: `modules/eks/outputs.tf`
Returns values to the root module.

```hcl
output "cluster_id" {
  description = "The ID of the EKS Cluster"
  value       = aws_eks_cluster.this.id
}

output "cluster_endpoint" {
  description = "Endpoint for EKS API Server"
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_security_group_id" {
  description = "Security Group ID attached to the EKS Cluster"
  value       = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
}

output "node_role_arn" {
  description = "ARN of the Node IAM Role"
  value       = aws_iam_role.eks_node_role.arn
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required for kubectl"
  value       = aws_eks_cluster.this.certificate_authority[0].data
}
```

---

## 2. Root Code: `day11/` (or Root Directory)

This file calls the module and sets up the VPC data sources.

### File: `main.tf`

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# ---------------------------------------------------
# DATA SOURCES: Fetch Existing Network
# ---------------------------------------------------
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# ---------------------------------------------------
# MODULE CALL: Deploy EKS
# ---------------------------------------------------
module "my_eks_cluster" {
  source = "../modules/eks" # Adjust path if running from a different folder

  cluster_name  = "my-production-cluster"
  vpc_id        = data.aws_vpc.default.id
  subnet_ids    = data.aws_subnets.default.ids
  instance_type = "t3.small"
  cluster_version = "1.29"
}

# ---------------------------------------------------
# OUTPUTS: Display Connection Info
# ---------------------------------------------------
output "cluster_endpoint" {
  description = "EKS API Endpoint"
  value       = module.my_eks_cluster.cluster_endpoint
}

output "kubectl_config_command" {
  description = "Command to update kubeconfig"
  value       = "aws eks update-kubeconfig --name ${module.my_eks_cluster.cluster_id} --region us-east-1"
}
```

---

## 3. How to Run

### Step 1: Initialize
Navigate to your root folder (e.g., `day11/`) and run:
```bash
terraform init
```

### Step 2: Plan
Verify what will be created:
```bash
terraform plan
```

### Step 3: Apply
Deploy the infrastructure. **This will take about 15-20 minutes.**
```bash
terraform apply
```

### Step 4: Configure kubectl
Once the apply is complete, copy the `kubectl_config_command` from the output and run it in your terminal, or run:
```bash
aws eks update-kubeconfig --name my-production-cluster --region us-east-1
```

### Step 5: Verify
Check your nodes:
```bash
kubectl get nodes
```
*You should see 2 nodes in `Ready` status.*
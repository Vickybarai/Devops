This code implements the "4 Pillars" strategy: Cluster Role, Cluster, Node Role, and Node Group, with the critical `timeouts` and `depends_on` configurations discussed in class.

---

### 📂 Module Structure: `modules/eks`

You should create three files inside this folder:
1.  `variables.tf` (Inputs)
2.  `main.tf` (Logic & Resources)
3.  `outputs.tf` (Outputs)

---

### 1. `variables.tf`
We define the inputs so this module can be reused for any VPC or environment.

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
  default     = "t3.small" # t3.small is recommended over t2.micro for EKS
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

---

### 2. `main.tf`
This is the core logic. It handles the IAM roles, the Cluster creation, and the Node Groups.

**Key Technical Details Included:**
*   **Cluster IAM Role:** Trusts `eks.amazonaws.com`.
*   **Node IAM Role:** Trusts `ec2.amazonaws.com` and has the 3 required policies attached.
*   **Timeouts:** Explicitly set to 20 minutes to prevent Terraform from failing during the long cluster boot process.
*   **Depends_on:** Ensures policies are attached *before* resources attempt to use the roles.

```hcl
# ---------------------------------------------------
# 1. CLUSTER IAM ROLE
# ---------------------------------------------------
resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.cluster_name}-cluster-role"

  # Trust Relationship: Allows the EKS Service to assume this role
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

# Attach the AWS Managed Policy for Cluster Control Plane
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

# ---------------------------------------------------
# 2. EKS CLUSTER (The Control Plane)
# ---------------------------------------------------
resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = var.cluster_version

  vpc_config {
    subnet_ids = var.subnet_ids
    # Ensure public access is enabled if you want to access the API endpoint from outside the VPC
    endpoint_public_access = true 
  }

  # CRITICAL: Cluster creation takes ~15-20 minutes. 
  # Terraform defaults to 10 mins. We MUST override this.
  timeouts {
    create = "20m"
    delete = "20m"
  }

  # CRITICAL: Ensure the policy is attached before the cluster tries to start.
  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy
  ]

  tags = {
    Name = var.cluster_name
  }
}

# ---------------------------------------------------
# 3. NODE IAM ROLE (For Worker Nodes)
# ---------------------------------------------------
resource "aws_iam_role" "eks_node_role" {
  name = "${var.cluster_name}-node-role"

  # Trust Relationship: Allows EC2 Service to assume this role
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
# 1. Allows nodes to join the cluster
resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_role.name
}

# 2. Allows CNI (Networking) to work
resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_role.name
}

# 3. Allows nodes to pull images from ECR
resource "aws_iam_role_policy_attachment" "eks_ecr_readonly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_role.name
}

# ---------------------------------------------------
# 4. EKS NODE GROUP (The Workers)
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

  # CRITICAL: Ensure all 3 policies are attached before creating the node group
  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.eks_ecr_readonly,
  ]

  # Ensure nodes are created after the cluster is ready
  depends_on = [
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

---

### 3. `outputs.tf`
We output these values so the root module (or a CI/CD pipeline) can use them to configure `kubectl` or deploy applications.

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
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = aws_eks_cluster.this.certificate_authority[0].data
}
```

---

### 🚀 How to Call This Module (Root `main.tf`)

To use the code above, you need to call this module from your root directory (e.g., `day11/main.tf`). Since the lecture mentioned using the **Default VPC**, here is how you fetch it and pass it to the module.

**File:** `day11/main.tf`

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

# 1. Fetch Default VPC
data "aws_vpc" "default" {
  default = true
}

# 2. Fetch Default Subnets
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# 3. Call the EKS Module
module "my_eks_cluster" {
  source = "./modules/eks"

  cluster_name = "my-production-cluster"
  vpc_id       = data.aws_vpc.default.id
  subnet_ids   = data.aws_subnets.default.ids
  instance_type = "t3.small"
}

# 4. Output the Cluster Endpoint so you can configure kubectl
output "cluster_endpoint" {
  value = module.my_eks_cluster.cluster_endpoint
}
```

### ⚠️ Critical Implementation Notes

1.  **Timeouts:** Without the `timeouts { create = "20m" }` block in the cluster resource, Terraform will timeout and fail after 10 minutes, but the cluster will actually still be creating in the background. This creates a "zombie" state.
2.  **Service Principals:** Notice the difference in `assume_role_policy`:
    *   Cluster uses `eks.amazonaws.com`.
    *   Node Role uses `ec2.amazonaws.com`.
    *   If you swap these, the creation will fail.
3.  **Node Group Policies:** The lecture emphasized attaching **exactly** these 3 policies to the Node Role (`AmazonEKSWorkerNodePolicy`, `AmazonEKS_CNI_Policy`, `AmazonEC2ContainerRegistryReadOnly`). Missing the CNI policy is the most common reason why nodes get stuck in `NotReady` status.
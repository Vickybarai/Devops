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
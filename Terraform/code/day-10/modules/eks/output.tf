output "cluster_id" {
  description = "The ID of the EKS Cluster"
  value       = aws_eks_cluster.my-cluster.id
}

output "cluster_endpoint" {
  description = "Endpoint for EKS API Server"
  value       = aws_eks_cluster.my-cluster.endpoint
}

output "cluster_security_group_id" {
  description = "Security Group ID attached to the EKS Cluster"
  value       = aws_eks_cluster.my-cluster.vpc_config[0].cluster_security_group_id
}

output "node_role_arn" {
  description = "ARN of the Node IAM Role"
  value       = aws_iam_role.eks_node_role.arn
}
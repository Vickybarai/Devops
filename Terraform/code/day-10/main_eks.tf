
# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 5.0"
#     }
#   }
# }

# provider "aws" {
#   region = "ca-central-1"
# }

# # ---------------------------------------------------
# # DATA SOURCES: Fetch Existing Network
# # ---------------------------------------------------
# data "aws_vpc" "default" {
#   default = true
# }

# data "aws_subnets" "default" {
#   filter {
#     name   = "vpc-id"
#     values = [data.aws_vpc.default.id]
#   }
# }

# # ---------------------------------------------------
# # MODULE CALL: Deploy EKS
# # ---------------------------------------------------
# module "my_eks_cluster" {
#   source = "./modules/eks" # Adjust path if running from a different folder

#   cluster_name  = "my-production-cluster"
#   vpc_id        = data.aws_vpc.default.id
#   subnet_ids    = data.aws_subnets.default.ids
#   instance_type = "t3.small"
#   cluster_version = "1.29"
# }
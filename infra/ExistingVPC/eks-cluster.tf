provider "aws" {
  region = "us-east-1"
}
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = local.cluster_name
  cluster_version = "1.21"
  subnets         = ["subnet-027766823d184045f","subnet-0df0d7fddc8a77d2f"]
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access = true
  cluster_iam_role_name = "VotingAppRole"
  manage_cluster_iam_resources = false
  manage_worker_iam_resources = false

  tags = {
    Environment = "test"
    GithubRepo  = "terraform-aws-eks"
    GithubOrg   = "terraform-aws-modules"
  }

  vpc_id = "vpc-0665efb7de3911681"
  workers_role_name = "NodeInstanceRole"
   node_groups_defaults = {
    ami_type  = "AL2_x86_64"
    disk_size = 20
  }

  node_groups = {
    example = {
      desired_capacity = 2
      max_capacity     = 2
      min_capacity     = 2
      iam_role_arn = "arn:aws:iam::051126537531:role/NodeInstanceRole"

      instance_types = ["t2.small"]
      capacity_type  = "SPOT"
      k8s_labels = {
        Environment = "test"
        GithubRepo  = "terraform-aws-eks"
        GithubOrg   = "terraform-aws-modules"
      }
      update_config = {
        max_unavailable_percentage = 50 # or set `max_unavailable`
      }
    }
  }
}
data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
locals {
  cluster_name = "mktst-nginx"
}

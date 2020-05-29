#############################################################################
# These values are placeholders. You should set and use the values of '../project.tfvars'
variable "project_name" {}
variable "region" {}
variable "profile" {}
variable "bucket" {}
#############################################################################
variable "cz_project" {}
variable "cz_stage" {}
variable "cz_owner" {}
variable "cz_org" {}
variable "cz_extra" {}
#############################################################################

variable "map_accounts" {
  description = "Additional AWS account numbers to add to the aws-auth configmap."
  type        = list(string)

  default = [
    "664311806486",
    "866648864905",
  ]
}

variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap."
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      rolearn  = "arn:aws:iam::664311806486:role/eks-basic-role"
      username = "system:node:{{EC2PrivateDNSName}}"
      groups   = ["system:masters", "system:bootstrappers", "system:nodes"]
    }
  ]
}

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      userarn  = "arn:aws:iam::664311806486:user/architect"
      username = "architect"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::664311806486:user/byungjoo.choi"
      username = "byungjoo.choi"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::664311806486:user/ghoostii"
      username = "ghoostii"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::664311806486:user/gudfoww"
      username = "gudfoww"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::664311806486:user/gyunghun1024"
      username = "gyunghun1024"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::664311806486:user/mgchang"
      username = "mgchang"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::664311806486:user/moojoon.kim"
      username = "moojoon.kim"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::664311806486:user/saejan"
      username = "saejan"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::664311806486:user/tf-build"
      username = "tf-build"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::664311806486:user/todend98"
      username = "todend98"
      groups   = ["system:masters"]
    }
  ]
}

locals {
  vpc_name = "${var.project_name}-vpc"
  miip_eks_name = "miip-d-cluster"

  ec2_keypair = "${var.project_name}-default-keypair"

  desired_capacity = 3
  max_capacity     = 10
  min_capacity     = 3
  instance_type    = "t3.large"
  worker_disk_size = 50

  gpu_desired_capacity = 1
  gpu_max_capacity     = 10
  gpu_min_capacity     = 1
  gpu_instance_type    = "t3.large"
  gpu_worker_disk_size = 50

}

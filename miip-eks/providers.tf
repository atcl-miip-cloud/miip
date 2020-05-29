provider "aws" {
  version = "~> 2.0"
  region  = var.region
  profile = var.profile
}

terraform {
  required_version = ">= 0.12.0"
  backend "s3" {
    key            = "project/eks-miip.tfstate"
    encrypt        = true
    acl            = "bucket-owner-full-control"
  }
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.mvp-eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.mvp-eks.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.mvp-eks.token
  load_config_file       = false
  version                = "~> 1.11"
}

provider "aws" {
  version = "~> 2.0"
  region  = var.region
  profile = var.profile
}

terraform {
  required_version = ">= 0.12.0"
  backend "s3" {
    key            = "project/ec2.tfstate"
    encrypt        = true
    acl            = "bucket-owner-full-control"
  }
}

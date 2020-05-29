data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_availability_zones" "available" {}

data "aws_vpc" "mvp-eks" {
  tags = {
    Name = local.vpc_name
  }
}

data "aws_subnet_ids" "mvp-eks" {
  vpc_id = data.aws_vpc.mvp-eks.id
}
data "aws_subnet" "mvp-eks" {
  for_each = data.aws_subnet_ids.mvp-eks.ids
  id       = each.value
}

data "aws_subnet_ids" "mvp-eks-pub" {
  vpc_id = data.aws_vpc.mvp-eks.id
  tags = {
    tier = "public"
  }
}
data "aws_subnet" "mvp-eks-pub" {
  for_each = data.aws_subnet_ids.mvp-eks-pub.ids
  id       = each.value
}

data "aws_subnet_ids" "mvp-eks-priv" {
  vpc_id = data.aws_vpc.mvp-eks.id
  tags = {
    tier = "private"
  }
}
data "aws_subnet" "mvp-eks-priv" {
  for_each = data.aws_subnet_ids.mvp-eks-priv.ids
  id       = each.value
}


resource "aws_security_group" "nodegrp-sg" {
  name_prefix = "${var.project_name}-nodegrp-sg"
  vpc_id      = data.aws_vpc.mvp-eks.id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "10.0.0.0/8",
    ]
  }
}

data "aws_eks_cluster" "mvp-eks" {
  name = module.mvp-eks.cluster_id
}

data "aws_eks_cluster_auth" "mvp-eks" {
  name = module.mvp-eks.cluster_id
}

module "mvp-eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_version = "1.16"
  cluster_name    = local.miip_eks_name
  vpc_id          = data.aws_vpc.mvp-eks.id
  subnets         = [for s in data.aws_subnet.mvp-eks-priv : s.id]

  write_kubeconfig = false

  # Modify these to control cluster access
  cluster_endpoint_private_access      = "true"
  cluster_endpoint_public_access       = "true"
  cluster_endpoint_public_access_cidrs = ["0.0.0.0/0", "211.45.60.5/32" ] #to limit access later

  node_groups_defaults = {
    ami_type  = "AL2_x86_64"
    disk_size = local.worker_disk_size
  }

  tags = {
    "cz.project"                                  = var.cz_project
    "cz.stage"                                    = var.cz_stage
    "cz.owner"                                    = var.cz_owner
    "cz.org"                                      = var.cz_org
    "cz.extra"                                    = var.cz_extra
  }

  node_groups = {
    mvp_nodes1 = {
      name                            = "${var.project_name}-default-nodegrp"
      subnets                         = [for s in data.aws_subnet.mvp-eks-priv : s.id]

      desired_capacity                = local.desired_capacity
      max_capacity                    = local.max_capacity
      min_capacity                    = local.min_capacity

      instance_type                   = local.instance_type

      cluster_endpoint_private_access = true
      additional_security_group_ids   = [aws_security_group.nodegrp-sg.id]
      k8s_labels = {
        env = "dev"
        gpu = "no"
      }
      additional_tags = {
        extra = "ext-tag test"
      }
      remote_access = {
        ec2_ssh_key = local.ec2_keypair
      }
    }
    mvp_nodes2 = {
      name                            = "${var.project_name}-gpu-nodegrp"
      subnets                         = [for s in data.aws_subnet.mvp-eks-priv : s.id]
      desired_capacity                = local.gpu_desired_capacity
      max_capacity                    = local.gpu_max_capacity
      min_capacity                    = local.gpu_min_capacity
      instance_type                   = local.gpu_instance_type
      cluster_endpoint_private_access = true
      additional_security_group_ids   = [aws_security_group.nodegrp-sg.id]
      k8s_labels = {
        env = "dev",
        gpu = "yes"
      }
      additional_tags = {
        extra = "gpu"
      }
      remote_access = {
        ec2_ssh_key = local.ec2_keypair
      }
    }
  }

  map_roles    = var.map_roles
  map_users    = var.map_users
  map_accounts = var.map_accounts
}

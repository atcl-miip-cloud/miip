module "vpc-mvp" {
  source = "terraform-aws-modules/vpc/aws"

  name = local.vpc_name
  cidr = "10.13.0.0/16"

  azs              = sort(data.aws_availability_zones.azs.names)
  public_subnets   = ["10.13.11.0/24", "10.13.21.0/24", "10.13.31.0/24"]
  private_subnets  = ["10.13.111.0/24", "10.13.121.0/24", "10.13.131.0/24"]
  database_subnets = ["10.13.114.0/24", "10.13.124.0/24", "10.13.134.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = false

  enable_vpn_gateway = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_s3_endpoint = true

  # create_database_subnet_group = true

  enable_ssm_endpoint              = true
  ssm_endpoint_private_dns_enabled = true
  ssm_endpoint_security_group_ids  = [data.aws_security_group.default.id]

  enable_efs_endpoint              = true
  efs_endpoint_private_dns_enabled = true
  efs_endpoint_security_group_ids  = [data.aws_security_group.default.id]

  tags = {
    "cz.project"                                  = var.cz_project
    "cz.stage"                                    = var.cz_stage
    "cz.owner"                                    = var.cz_owner
    "cz.org"                                      = var.cz_org
    "cz.extra"                                    = var.cz_extra
    "kubernetes.io/cluster/${local.pms_eks_name}" = "shared",
    "kubernetes.io/cluster/${local.oc_eks_name}"  = "shared",
  }

  public_subnet_tags = {
    "tier"                   = "public"
    "kubernetes.io/role/elb" = "1"
  }

  private_subnet_tags = {
    "tier"                            = "private"
    "kubernetes.io/role/internal-elb" = "1"
  }

  database_subnet_tags = {
    "tier" = "database"
  }

  vpc_endpoint_tags = {
    "endpoint" = "true"
  }
}

data "aws_security_group" "default" {
  name   = "default"
  vpc_id = module.vpc-mvp.vpc_id
}

data "aws_availability_zones" "azs" {
  state = "available"
}

output "vpc_name" {
  value = local.vpc_name
}

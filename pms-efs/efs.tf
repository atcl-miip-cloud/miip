# EFS File System with tags & lifecycle policy
resource "aws_efs_file_system" "pms-d-accu-efs-vol1" {
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }

  tags = {
    "cz.project" = var.cz_project
    "cz.stage"   = var.cz_stage
    "cz.owner"   = var.cz_owner
    "cz.org"     = var.cz_org
    "cz.extra"   = var.cz_extra
  }
}

data "aws_vpc" "mvp-efs" {
  tags = {
    Name = local.vpc_name
  }
}

data "aws_subnet_ids" "mvp-priv" {
  vpc_id = data.aws_vpc.mvp-efs.id
  tags = {
    tier = "private"
  }
}

data "aws_subnet" "mvp-priv" {
  for_each = data.aws_subnet_ids.mvp-priv.ids
  id       = each.value
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_availability_zones" "available" {}


resource "aws_efs_mount_target" "pms-efs-tg" {
  count          = length([for s in data.aws_subnet.mvp-priv : s.id])
  file_system_id = aws_efs_file_system.pms-d-accu-efs-vol1.id
  subnet_id      = element([for s in data.aws_subnet.mvp-priv : s.id], count.index)
  # security_groups = ["${aws_security_group.efs-sg.id}"]
}

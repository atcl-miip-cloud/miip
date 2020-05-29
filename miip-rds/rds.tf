
data "aws_vpc" "mvp-rds" {
  tags = {
    Name = local.vpc_name
  }
}

data "aws_subnet_ids" "mvp-rds" {
  vpc_id = data.aws_vpc.mvp-rds.id
  tags = {
    tier = "database"
  }
}

data "aws_security_group" "default" {
  vpc_id = "${data.aws_vpc.mvp-rds.id}"
  name   = "default"
}


module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = local.rds_identifier
  name = local.rds_db_name

  engine            = "mariadb"
  engine_version    = "10.4.8"
  instance_class    = "db.t2.large"
  allocated_storage = 20

  # kms_key_id        = "arm:aws:kms:<region>:<accound id>:key/<kms key id>"
  storage_encrypted = false

  # NOTE: Do NOT use 'user' as the value for 'username' as it throws:
  # "Error creating DB Instance: InvalidParameterValue: MasterUsername
  # user cannot be used as it is a reserved word used by the engine"
  username = "manager"
  password = "YourPwdShouldBeLongAndSecure!"
  port     = "3306"

  vpc_security_group_ids = ["${data.aws_security_group.default.id}"]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  # disable backups to create DB faster
  backup_retention_period = 0

  tags = {
    "cz.project" = var.cz_project
    "cz.stage"   = var.cz_stage
    "cz.owner"   = var.cz_owner
    "cz.org"     = var.cz_org
    "cz.extra"   = var.cz_extra
  }

  # DB subnet group
  subnet_ids = data.aws_subnet_ids.mvp-rds.ids

  # DB parameter group
  family = "mariadb10.4"

  # DB option group
  major_engine_version = "10.4"

  # Snapshot name upon DB deletion
  final_snapshot_identifier = "demodb"

  parameters = [
    {
      name  = "character_set_client"
      value = "utf8"
    },
    {
      name  = "character_set_server"
      value = "utf8"
    }
  ]

  options = [
    {
      option_name = "MARIADB_AUDIT_PLUGIN"

      option_settings = [
        {
          name  = "SERVER_AUDIT_EVENTS"
          value = "CONNECT"
        },
        {
          name  = "SERVER_AUDIT_FILE_ROTATIONS"
          value = "37"
        },
      ]
    },
  ]
}

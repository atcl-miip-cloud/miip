data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_vpc" "mvp-es" {
  tags = {
    Name = local.vpc_name
  }
}

data "aws_subnet" "mvp-es" {
  vpc_id = data.aws_vpc.mvp-es.id
  tags = {
    tier = "private"
  }
  availability_zone = "${var.region}a"
}

resource "aws_elasticsearch_domain" "mvp-es" {
  domain_name           = local.es_name
  elasticsearch_version = "7.1"

  cluster_config {
    instance_type  = "t2.medium.elasticsearch"
    instance_count = 2
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 30
  }

  vpc_options {
    subnet_ids         = [data.aws_subnet.mvp-es.id]
    security_group_ids = [aws_security_group.es.id]
  }

  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }

  access_policies = <<CONFIG
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "es:*",
            "Principal": "*",
            "Effect": "Allow",
            "Resource": "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${local.es_name}/*"
        }
    ]
}
CONFIG

  snapshot_options {
    automated_snapshot_start_hour = 23
  }

  tags = {
    Domain      = var.project_name
    "cz.project" = var.cz_project
    "cz.stage"   = var.cz_stage
    "cz.owner"   = var.cz_owner
    "cz.org"     = var.cz_org
    "cz.extra"   = var.cz_extra
  }
}

output "ElasticSearch_Endpoint" {
  description = "Elasticsearch Enpoint"
  value       = "https://${aws_elasticsearch_domain.mvp-es.endpoint}"
}

output "Kibana_Endpoint" {
  description = "Kibana Enpoint"
  value       = "https://${aws_elasticsearch_domain.mvp-es.kibana_endpoint}"
}

# S3 : 특별한 요구사항은 없다, 저장만 가능하면 됨, 여기는 s3 자체의 엑세스 기록을 위해 log bucket을 추가한다.
resource "aws_s3_bucket" "mvp_tfstate" {
  bucket = var.bucket
  acl    = "private"
  tags = {
    "cz.project" = var.cz_project
    "cz.stage"   = var.cz_stage
    "cz.owner"   = var.cz_owner
    "cz.org"     = var.cz_org
    "cz.extra"   = var.cz_extra
  }

  versioning {
    enabled = true
  }
  logging {
    target_bucket = aws_s3_bucket.s3_logs.id
    target_prefix = "tfaccesslogs/"
  }
  lifecycle {
    prevent_destroy = false
  }
}

# s3 log용 bucket 생성
resource "aws_s3_bucket" "s3_logs" {
  bucket = "${var.bucket}.logs"
  acl    = "log-delivery-write"
  tags = {
    "cz.project" = var.cz_project
    "cz.stage"   = var.cz_stage
    "cz.owner"   = var.cz_owner
    "cz.org"     = var.cz_org
    "cz.extra"   = var.cz_extra
  }
}

# 디폴트 EC2-SSH-Key 생성
resource "aws_key_pair" "default_keypair" {
  key_name   = local.ec2_keypair_name
  public_key = local.public_key
}

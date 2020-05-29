resource "aws_s3_bucket" "tableaudev" {
  bucket = "skbm-tableaudev-${random_string.suffix.result}"
  acl    = "private"
  tags   = {
    "cz.project" = var.cz_project
    "cz.stage"   = var.cz_stage
    "cz.owner"   = var.cz_owner
    "cz.org"     = var.cz_org
    "cz.extra"   = var.cz_extra
  }

  versioning {
    enabled = true
  }
  lifecycle {
    prevent_destroy = false
  }
}
resource "aws_s3_bucket" "tamrdev" {
  bucket = "skbm-tamrdev-${random_string.suffix.result}"
  acl    = "private"
  tags   = {
    "cz.project" = var.cz_project
    "cz.stage"   = var.cz_stage
    "cz.owner"   = var.cz_owner
    "cz.org"     = var.cz_org
    "cz.extra"   = var.cz_extra
  }

  versioning {
    enabled = true
  }
  lifecycle {
    prevent_destroy = false
  }
}
resource "aws_s3_bucket" "dotstest" {
  bucket = "skbm-dotstest-${random_string.suffix.result}"
  acl    = "private"
  tags   = {
    "cz.project" = var.cz_project
    "cz.stage"   = var.cz_stage
    "cz.owner"   = var.cz_owner
    "cz.org"     = var.cz_org
    "cz.extra"   = var.cz_extra
  }

  versioning {
    enabled = true
  }
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_s3_bucket" "tamrdev2" {
  bucket = "skbm-tamrdev2-${random_string.suffix.result}"
  acl    = "private"
  tags   = {
    "cz.project" = var.cz_project
    "cz.stage"   = var.cz_stage
    "cz.owner"   = var.cz_owner
    "cz.org"     = var.cz_org
    "cz.extra"   = var.cz_extra
  }

  versioning {
    enabled = true
  }
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_s3_bucket" "dotsweb" {
  bucket = "skbm-miip-d-dotsweb-public-${random_string.suffix.result}"
  acl    = "private"
  tags   = {
    "cz.project" = var.cz_project
    "cz.stage"   = var.cz_stage
    "cz.owner"   = var.cz_owner
    "cz.org"     = var.cz_org
    "cz.extra"   = var.cz_extra
  }

  versioning {
    enabled = true
  }
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_s3_bucket_policy" "dotsweb" {
  bucket = aws_s3_bucket.dotsweb.id

  policy = <<POLICY
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Sid":"PublicRead",
      "Effect":"Allow",
      "Principal": "*",
      "Action":["s3:GetObject"],
      "Resource":["arn:aws:s3:::${aws_s3_bucket.dotsweb.id}/*"]
    }
  ]
}
POLICY
}

resource "aws_s3_bucket" "dots" {
  bucket = "skbm-miip-d-dots-private-${random_string.suffix.result}"
  acl    = "private"
  tags   = {
    "cz.project" = var.cz_project
    "cz.stage"   = var.cz_stage
    "cz.owner"   = var.cz_owner
    "cz.org"     = var.cz_org
    "cz.extra"   = var.cz_extra
  }

  versioning {
    enabled = true
  }
  lifecycle {
    prevent_destroy = false
  }
}



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

resource "random_string" "suffix" {
  length  = 6
  min_lower = 1
  min_numeric = 1
  special = false
  upper = false
}

locals {
  bucket_name = "${var.project_name}-${random_string.suffix.result}"
  log_bucket_name = "${var.project_name}-${random_string.suffix.result}-logs"
}

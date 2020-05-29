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

locals {
  vpc_name = "${var.project_name}-vpc"
  efs_name = "${var.project_name}-efs"
}
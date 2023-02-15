variable "parent" {
  type    = string
  default = "organizations/878834039720"
}

variable "billing_account" {
  type    = string
  default = "01BEC7-57393B-ED23D5"
}

variable "org_id" {
  type    = string
  default = "878834039720"
}

variable "state_bucket_name" {
  type    = string
  default = "terragrunt-iac-core-bkt"
}

variable "default_region" {
  type    = string
  default = "us-central1"
}
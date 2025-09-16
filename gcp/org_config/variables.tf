variable "org_policy_name" {
  description = "org global policy id"
  type        = string
}

variable "perimeter_name" {
  description = "perimeter name"
  type        = string
}

variable "vpc_sc_services" {
  description = "List of VPC SC restricted services"
  type        = list(string)
}

variable "vms_with_public_ips" {
  type = list(string)
}

variable "org_id" {
  type = string
}

variable "billing_account" {
  type = string
}
 

resource "random_id" "random_suffix" {
  byte_length = 2
}

 

#module "access_context_manager_policy" {
#  source  = "terraform-google-modules/vpc-service-controls/google"
#  version = "~> 6.0"
# 
#  parent_id   = "987000039256"
#  policy_name = "int_test_vpc_sc_policy_${random_id.random_suffix.hex}"
#}

 

module "access_level_vpc_ranges" {
  source      = "terraform-google-modules/vpc-service-controls/google//modules/access_level"
  policy      = module.org_policy.policy_id
  name        = "vpc_ip_address_policy"
  description = "access level for vpc ip addresses"
  vpc_network_sources = {
    "vpc_paullab-vpc" = {
      network_id = "paullab-vpc"
    }
  }

}

#resource "google_access_context_manager_access_level" "access-level" {
#  parent = "accessPolicies/686487341936"
#  name   = "accessPolicies/686487341936/accessLevels/onprem_prod_subnets"
#  title  = "onprem_prod_subnets"
#  basic {
#    conditions {
#      vpc_network_sources = ["projects/cogent-dragon-379819/global/networks/paullab-vpc"]
#    }
#  }
#}

# vpc service controls
#provider "google" {
#  version = "~> 3.19.0"
#}

module "org_policy" {
  source      = "terraform-google-modules/vpc-service-controls/google"
  parent_id   = "987000039256"
  policy_name = "sample-vpc-sc-permimeter"
}

#module "access_level_members" {
#  source  = "terraform-google-modules/vpc-service-controls/google//modules/access_level"
#  policy  = module.org_policy.policy_id
#  name    = "terraform_members"
#  members = var.members
#}

module "regular_service_perimeter_1" {
  source              = "terraform-google-modules/vpc-service-controls/google//modules/regular_service_perimeter"
  policy              = module.org_policy.policy_id
  perimeter_name      = "regular_perimeter_1"
  description         = "Perimeter shielding projects"
  resources_dry_run           = ["127799619174"]
#  access_levels       = [module.access_level_members.name]
  restricted_services_dry_run = ["bigquery.googleapis.com", "storage.googleapis.com"]
#  shared_resources    = {
#    all = ["11111111"]
#  }
}

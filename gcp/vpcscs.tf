 

resource "random_id" "random_suffix" {
  byte_length = 2
} 

module "access_level_vpc_ranges" {
  source      = "terraform-google-modules/vpc-service-controls/google//modules/access_level"
  policy      = var.org_policy_name
  name        = "vpc_ip_address_policy"
  description = "access level for vpc ip addresses"
  vpc_network_sources = {
    "vpc_paullab-vpc" = {
      network_id = "projects/cogent-dragon-379819/global/networks/paullab-vpc"
    }
  }
}

module "org_policy" {
  source      = "terraform-google-modules/vpc-service-controls/google"
  parent_id   = "987000039256"
  policy_name = "sample-vpc-sc-permimeter"
}

resource "google_access_context_manager_service_perimeters" "service-perimeter" {
  parent = "accessPolicies/686487341936"

  service_perimeters {
    name   = "accessPolicies/686487341936/servicePerimeters/thisisperimetername"
    title  = "title001"
    status {
      restricted_services = ["storage.googleapis.com"]
    }
  }

}



#  module "regular_service_perimeter_1" {
#    source                      = "terraform-google-modules/vpc-service-controls/google# modules/regular_service_perimeter"
#    policy                      = var.org_policy_name
#    perimeter_name              = "regular_perimeter_1"
#    description                 = "Perimeter shielding projects"
#    resources_dry_run           = ["127799619174"]
#    restricted_services_dry_run = ["bigquery.googleapis.com", "storage.googleapis.com"]
#    ingress_policies = [
#      {
#        title = "Allow Access from everywhere"
#        from = {
#          sources = {
#            access_levels = ["*"] # Allow Access from everywhere
#          },
#          identities = ["user:paulmsullivan@gmail.com"]

#        }
#        to = {
#          resources = [
#            "*"
#          ]
#          operations = {
#            "storage.googleapis.com" = {
#              methods = [
#                "google.storage.objects.get",
#                "google.storage.objects.list"
#              ]
#            }
#          }
#        }
#      }
#    ]
#  }

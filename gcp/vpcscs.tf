
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

resource "google_access_context_manager_service_perimeter" "service-perimeter" {
  parent = "accessPolicies/${var.org_policy_name}"
  name   = "accessPolicies/${var.org_policy_name}/servicePerimeters/draft"
  title  = "draft"
  status {
    restricted_services = ["storage.googleapis.com"]




    ingress_policies {
      title = "rule 001"
      ingress_from {
        identity_type = "ANY_IDENTITY"
        sources {
          access_level = "*"
        }
      }
      ingress_to {
        operations {
          service_name = "storage.googleapis.com"
          method_selectors {
            method = "google.storage.objects.get"
          }
        }
      }
    }

    ingress_policies {
      title = "rule 002"
      ingress_from {
    identity_type = "ANY_IDENTITY"
    sources {
      access_level = "*"
    }
      }
      ingress_to {
        operations {
          service_name = "bigquery.googleapis.com"
          method_selectors {
            method = "*"
          }
        }
      }
    }




  }
  use_explicit_dry_run_spec = true
}


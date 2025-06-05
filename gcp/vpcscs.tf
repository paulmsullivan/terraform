 

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


module "nonprod_public_ip_access_level" {
  source      = "terraform-google-modules/vpc-service-controls/google//modules/access_level"
  policy      = var.org_policy_name
  name        = "nonprod_public_ips"
  description = "public ip ranges for nonprod access level"
  ip_subnetworks = ["64.201.224.0/21",
                    "199.47.104.0/21",
                    "69.25.46.0/24",
                    "216.52.121.0/24",
                    "198.62.120.0/24",
                    "38.92.135.0/24",
                    "38.126.162.0/24",
                    "63.251.92.0/24",
                    "4.7.223.61/32",
                    "50.216.60.98/32",
                    "4.30.231.129/32",
                    "4.157.58.65/32",
                    "209.119.136.18/32",
                    "128.177.81.62/32",
                    "65.207.61.192/27",
                    "208.45.191.192/29"]
}


module "draft_main_service_perimeter" {
  source                      = "terraform-google-modules/vpc-service-controls/google//modules/regular_service_perimeter"
  policy                      = var.org_policy_name
  perimeter_name              = "draft"
  description                 = "DRAFT (empty) Perimeter shielding projects"
  resources_dry_run           = [] 
  # eventually look to use a variable when implementing: var.vpc_sc_nonprod_projects
  restricted_services_dry_run = var.vpc_sc_services
  access_levels_dry_run = ["nonprod_public_ips"]  

   ingress_policies = [
     {
       title = "Allow Access from everywhere"
       from = {
         sources = {
           access_levels = ["*"] Allow Access from everywhere
         },
         identities = ["user:paulmsullivan@gmail.com"]

       }
       to = {
         resources = [
           "*"
         ]
         operations = {
           "storage.googleapis.com" = {
             methods = [
               "google.storage.objects.get",
               "google.storage.objects.list"
             ]
           }
         }
       }
     }
   ]

}




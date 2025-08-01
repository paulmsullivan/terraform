
# Creates an Access Level
# This access level will be used in
# a conditional IAM policy to restrict access
# to authorised users coming from authorised networks

module "new_us_geo_access_level" {
  source      = "terraform-google-modules/vpc-service-controls/google//modules/access_level"
  policy      = "686487341936"
  name        = "us_geo_access_level"
  description = "US Region and Our VPCs"
  regions = ["US"]
  combining_function = "OR"
  vpc_network_sources = {
    "vpc_labvms" = {
      network_id = "projects/cogent-dragon-379819/global/networks/paullab-vpc"
    }
  }
}

resource "google_access_context_manager_access_level" "access-level" {
  parent      = "accessPolicies/686487341936"
  name        = "accessPolicies/686487341936/accessLevels/usregion"
  title       = "from_us_region"
  description = "This access level lists the authorised network addresses"
  basic {
    conditions {
      regions = ["US"]
     }
  }
}



# Create a conditional IAM rule that grants access to establish an IAP tunnel
# IF the user is connecting from an authorised network defined in the access 
# list
resource "google_iap_tunnel_iam_member" "allow-remote-access-to-iap" {
  project = "cogent-dragon-379819"
  role    = "roles/iap.tunnelResourceAccessor"
  member  = "user:paul.sullivan@sobekdigital.com"

  condition {
    title       = "allow_iap_access_from_us_region"
    description = "Allow access to IAP tunnel for authorized users from US region"
    expression  = "\"accessPolicies/686487341936/accessLevels/usregion\" in request.auth.access_levels"
  }
}

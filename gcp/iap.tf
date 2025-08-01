
# Creates an Access Level
# This access level will be used in
# a conditional IAM policy to restrict access
# to authorised users coming from authorised networks

resource "google_access_context_manager_access_level" "access-level" {
  parent      = "accessPolicies/686487341936"
  name        = "accessPolicies/686487341936/accessLevels/usregion"
  title       = "from_us_region"
  description = "This access level lists the authorised network addresses"
  basic {
    combining_function = "OR"
    conditions {
      regions = ["US"]
      vpc_network_sources = ["projects/cogent-dragon-379819/global/networks/paullab-vpc"]
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

# Create a conditional IAM rule that grants access to establish an IAP tunnel
# IF the user is connecting from an authorised network defined in the access 
# list
resource "google_iap_tunnel_iam_member" "allow-remote-access-to-iap" {
    project = "cogent-dragon-379819"
    role    = "roles/iap.tunnelResourceAccessor"
    member  = "user:paul.sullivan@sobekdigital.com"

#    condition {
#      title = "allow_remote_access_to_iap"
#      description = "Allow access to IAP tunnel for authorized users"
#      expression = "\"accessPolicies/<access-policy-id>/accessLevels/<my-access-level-name>\" in request.auth.access_levels"
#    }
}

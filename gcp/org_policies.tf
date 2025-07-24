
resource "google_organization_policy" "public_ip_policy" {
  org_id = "987000039256"
  constraint = "compute.vmExternalIpAccess"

  list_policy {
    allow {
      values = ["projects/cogent-dragon-379819/zones/us-central1-c/instances/paullab-vm1","projects/wordpress-446723/zones/us-central1-a/instances/wordpress-1-vm"]
    }
  }
}


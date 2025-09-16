
resource "google_folder" "upper" {
  display_name = "Upper"
  parent       = "organizations/${var.org_id}"
}



resource "google_folder" "lower" {
  display_name = "Lower"
  parent       = "organizations/${var.org_id}"
  deletion_protection = false
}

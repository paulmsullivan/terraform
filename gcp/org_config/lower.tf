
resource "google_folder" "lower" {
  display_name = "Lower"
  parent       = "organizations/${var.org_id}"
  deletetion_protection = false
}

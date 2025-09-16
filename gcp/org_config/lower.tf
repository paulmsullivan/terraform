
resource "google_folder" "lower" {
  display_name = "Lower"
  parent       = "organizations/${var.org_id}"
}

resource "google_project" "lowerproject" {
    name            = "lowerproject"
    project_id      = "lowerproject"
    billing_account = var.gcp-billing-account
    folder_id       = google_folder.lower.name
    auto_create_network = false
}

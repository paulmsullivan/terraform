
resource "google_folder" "upper" {
  display_name = "Upper"
  parent       = "organizations/${var.org_id}"
}

resource "google_project" "upperproject" {
    name            = "upperproject"
    project_id      = "upperproject"
    billing_account = var.billing_account
    folder_id       = google_folder.upper.name
    auto_create_network = false
}

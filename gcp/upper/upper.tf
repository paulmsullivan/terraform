#
# updated comments - updated again
#
terraform {
  cloud {
    organization = "paulmsullivan"

    workspaces {
      name = "gcp-lab-upper"
    }
  }
}

#
# Credentials for Terraform to auth to GCP for operations.
# The values set here will be inherited by the resources
# below such as "project","region","zone"
#
provider "google" {
  credentials = var.gcp-cred
  project     = "cogent-dragon-379819"
  region      = "us-central1"
  zone        = "us-central1-c"
}



resource "google_folder" "upper" {
  display_name = "Upper"
  parent       = "organizations/${var.org_id}"
  deletion_protection = false
}

resource "google_project" "upperproject" {
    name            = "upperproject"
    project_id      = "upperproject"
    billing_account = var.gcp-billing-account
    folder_id       = google_folder.upper.name
    auto_create_network = false
    deletion_policy = "DELETE"
}

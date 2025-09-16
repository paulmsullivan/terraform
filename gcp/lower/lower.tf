#
# updated comments - updated again
#
terraform {
  cloud {
    organization = "paulmsullivan"

    workspaces {
      name = "gcp-lab-lower"
    }
  }
}

variable "gcp-cred" {
  type    = string
  default = ""
}

variable "gcp-billing-account" {
  type    = string
  default = ""
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



resource "google_folder" "lower" {
  display_name = "Lower"
  parent       = "organizations/${var.org_id}"
}

resource "google_project" "lowerproject" {
    name            = "lowerproject"
    project_id      = "lowerproject-876584"
    billing_account = var.gcp-billing-account
    folder_id       = google_folder.lower.name
    auto_create_network = false
}

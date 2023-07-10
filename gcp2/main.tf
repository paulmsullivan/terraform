#
#
terraform {
  cloud {
    organization = "sobekdigital.com"

    workspaces {
      name = "gcp-sobekcm"
    }
  }
}

variable "gcp2-creds" {
  type = string
  default = ""
}

#
# Credentials for Terraform to auth to GCP for operations.
# The values set here will be inherited by the resources
# below such as "project","region","zone"
#
provider "google" {
  credentials = var.gcp2-creds
  project = "golden-keel-392422"
  region  = "us-central1"
  zone    = "us-central1-c"
}

module "project-factory_project_services" {
  source     = "terraform-google-modules/project-factory/google//modules/project_services"
  version    = "14.1.0"
  project_id = "golden-keel-392422"
 
  activate_apis = [
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com",
    "iam.googleapis.com",
  ]
}

resource "google_project_iam_custom_role" "customVMStartStopv2" {
  role_id     = "customVMStartStopv2"
  title       = "Compute Instance Start and Stop"
  description = "Permits starting and stopping VM Instances"
  permissions = ["compute.instances.start", "compute.instances.stop", "compute.instances.suspend", "compute.instances.update"]
}

#
# Create a VPC resource
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network
#
resource "google_compute_network" "sobek-vpc" {
  name = "sobek-vpc"
  auto_create_subnetworks = false
}

#
# Create a subnet
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork
#
resource "google_compute_subnetwork" "vms-dmz-subnet" {
  name          = "vms-dmz-subnet"
  ip_cidr_range = "10.100.0.0/24"
  network       = google_compute_network.sobek-vpc.id
}

#
# Create a schedule that can be attached to VMs to stop at 1am daily
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_resource_policy
# some tips on writing the schedule values:
# https://stackoverflow.com/questions/71672166/how-to-schedule-a-vm-to-stop-on-a-different-day
# schedule 5 values seem to be (minute of the hour)(hour of the day)(day of the month)(month)(day of week)
#
resource "google_compute_resource_policy" "daily-0100-stop" {
  name   = "daily-0100-stop"
  description = "Start and stop instances"  

  instance_schedule_policy {
    vm_stop_schedule {
      schedule = "0 1 * * *"
    }
    time_zone = "America/New_York"
  }

}

#
# Create a schedule that can be attached to disk to take a snapshot
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_resource_policy
#
resource "google_compute_resource_policy" "daily-backup" {
  name   = "daily-backup"

  snapshot_schedule_policy {
    schedule {
      daily_schedule {
        days_in_cycle = 1
        start_time    = "04:00"
      }
    }
    retention_policy {
      max_retention_days    = 7
      on_source_disk_delete = "APPLY_RETENTION_POLICY"
    }
  }

}

#
# attach a policy (snapshot schedule etc) to a disk
#

#resource "google_compute_disk_resource_policy_attachment" "attachment" {
#  name = google_compute_resource_policy.daily-backup.name
#  disk = google_compute_instance.paullab-vm1.name
#}

#resource "google_organization_policy" "public_ip_policy" {
#  org_id = "987000039256"
#  constraint = "compute.vmExternalIpAccess"
#
#  list_policy {
#    allow {
#      values = ["projects/cogent-dragon-379819/zones/us-central1-c/instances/paullab-vm1"]
#    }
#  }
#}

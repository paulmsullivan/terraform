#
# updated comments - updated again
#
terraform {
  cloud {
    organization = "paulmsullivan"

    workspaces {
      name = "gcp-lab-org"
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

resource "google_project_service" "project" {
  service = "iam.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }

  disable_on_destroy = false
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
resource "google_compute_network" "paullab-vpc" {
  name                    = "paullab-vpc"
  auto_create_subnetworks = false
}

#
# Create a subnet
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork
#
resource "google_compute_subnetwork" "paullab-subnetwork" {
  name          = "paullab-subnetwork"
  ip_cidr_range = "10.10.0.0/24"
  network       = google_compute_network.paullab-vpc.id
}

#
# Create a schedule that can be attached to VMs to stop at 1am daily
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_resource_policy
# some tips on writing the schedule values:
# https://stackoverflow.com/questions/71672166/how-to-schedule-a-vm-to-stop-on-a-different-day
# schedule 5 values seem to be (minute of the hour)(hour of the day)(day of the month)(month)(day of week)
#
resource "google_compute_resource_policy" "daily-0100-stop" {
  name        = "daily-0100-stop"
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
  name = "daily-backup"

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

resource "google_compute_instance" "paullab-vm1" {
  name                      = "paullab-vm1"
  machine_type              = "e2-micro"
  allow_stopping_for_update = true

  resource_policies = [
    google_compute_resource_policy.daily-0100-stop.id
  ]

  tags = ["all-linux", "all-instance"]

  boot_disk {
    initialize_params {
      image = "ubuntu-2204-jammy-v20230302"
      labels = {
        my_label = "disk0"
      }
    }
  }

  network_interface {
    subnetwork = "paullab-subnetwork"

    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    foo = "bar"
  }

}

#
# attach a policy (snapshot schedule etc) to a disk
#
resource "google_compute_disk_resource_policy_attachment" "attachment" {
  name = google_compute_resource_policy.daily-backup.name
  disk = google_compute_instance.paullab-vm1.name
}

#resource "google_org_policy_policy" "project_public_ip_policy" {
#  name  = "projects/cogent-dragon-379819/policies/compute.vmExternalIPAccess"
#  parent = "projects/cogent-dragon-379819"
#
#  spec {
#    inherit_from_parent = true
#    reset = false
#
#    rules {
#      allow_all = "TRUE"
#    }
#  }
#
#}

resource "google_organization_policy" "serial_port_policy" {
  org_id     = var.org_id
  constraint = "compute.setNewProjectDefaultToZonalDNSOnly"

  boolean_policy {
    enforced = true
  }
}

## Allow incoming access to our instance via
## port 22, from the IAP servers
resource "google_compute_firewall" "inbound-iap-ssh" {
  name    = "allow-incoming-ssh-from-iap"
  network = google_compute_network.paullab-vpc.id

  direction = "INGRESS"
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = [
    "35.235.240.0/20"
  ]
  target_tags = ["all-linux"]
}

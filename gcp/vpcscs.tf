
resource "random_id" "random_suffix" {
  byte_length = 2
} 

module "access_level_vpc_ranges" {
  source      = "terraform-google-modules/vpc-service-controls/google//modules/access_level"
  policy      = var.org_policy_name
  name        = "vpc_ip_address_policy"
  description = "access level for vpc ip addresses"
  vpc_network_sources = {
    "vpc_paullab-vpc" = {
      network_id = "projects/cogent-dragon-379819/global/networks/paullab-vpc"
    }
  }
}

module "org_policy" {
  source      = "terraform-google-modules/vpc-service-controls/google"
  parent_id   = "987000039256"
  policy_name = "sample-vpc-sc-permimeter"
}

resource "google_access_context_manager_service_perimeter" "service-perimeter" {
  parent = "accessPolicies/${var.org_policy_name}"
  name   = "accessPolicies/${var.org_policy_name}/servicePerimeters/draft"
  title  = "draft"

  # "status" = enforced config
  status {
    restricted_services = ["storage.googleapis.com"]

    ingress_policies {
      title = "[INF-834] service-org-1041583873210-gcp-sa-logging"
      ingress_from {
        identities = ["serviceAccount:service-org-1041583873210@gcp-sa-logging.iam.gserviceaccount.com"]
        sources {
          access_level = "*"
        }
      }
      ingress_to {
        operations {
          service_name = "pubsub.googleapis.com"
          method_selectors {
            method = "Publisher.Publish"
          }
        }
      }
    }

    ingress_policies {
      title = "[INF-838] Blackhills"
      ingress_from {
        identities = ["serviceAccount:bhiselasticagent@prod-gcp-378519.iam.gserviceaccount.com"]
        sources {
          access_level = "*"
        }
      }
      ingress_to {
        operations {
          service_name = "pubsub.googleapis.com"
          method_selectors {
            method = "Subscriber.Acknowledge"
          }
          method_selectors {
            method = "Subscriber.ModifyAckDeadline"
          }
          method_selectors {
            method = "Subscriber.StreamingPull"
          }
        }
      }
    }

   ingress_policies {
      title = "[INF-839] svc-crowdstrike"
      ingress_from {
        identities = ["serviceAccount:svc-crowdstrike@ss-security-iam.iam.gserviceaccount.com"]
        sources {
          access_level = "*"
        }
      }
      ingress_to {
        operations {
          service_name = "*"
        }
      }
    }

    ingress_policies {
      title = "[INF-840] ss-security-iam"
      ingress_from {
        identities = ["serviceAccount:ss-security-iam@appspot.gserviceaccount.com"]
        sources {
          access_level = "*"
        }
      }
      ingress_to {
        operations {
          service_name = "logging.googleapis.com"
          method_selectors {
            method = "LoggingServiceV2.ListLogEntries"
          }
        }
        operations {
          service_name = "cloudasset.googleapis.com"      
          method_selectors {
            method = "*"
          }
        }
        operations {
          service_name = "iam.googleapis.com"   
          method_selectors {
            method = "*"
          }
        }        
      }
    }

    ingress_policies {
      title = "[INF-841] Security Center"
      ingress_from {
        identities = ["serviceAccount:service-org-1041583873210@gcp-sa-chronicle-soar.iam.gserviceaccount.com",
                      "serviceAccount:service-org-1041583873210@security-center-api.iam.gserviceaccount.com"]
        sources {
          access_level = "*"
        }
      }
      ingress_to {
        operations {
          service_name = "iam.googleapis.com"
          method_selectors {
            method = "WorkloadIdentityPools.ListWorkloadIdentityPools"
          }
          method_selectors {
            method = "IAM.GetRole"
          }         
        }
        operations {
          service_name = "pubsub.googleapis.com"   
          method_selectors {
            method = "Publisher.GetTopic"
          } 
          method_selectors {
            method = "Subscriber.Acknowledge"
          } 
          method_selectors {
            method = "Subscriber.GetSubscription"
          }           
          method_selectors {
            method = "Subscriber.Pull"
          } 
        }
        operations {
          service_name = "compute.googleapis.com" 
          method_selectors {
            method = "*"
          }
        }        
      }
    }

    ingress_policies {
      title = "[INF-835] Kubernetes DNS"
      ingress_from {
        identities = ["serviceAccount:svc-externaldns@devint-gke-778534.iam.gserviceaccount.com",
                      "serviceAccount:svc-externaldns@prod-gke-867530.iam.gserviceaccount.com",
                      "serviceAccount:svc-externaldns@systest-gke-543261.iam.gserviceaccount.com",
                      "serviceAccount:bhiselasticagent@prod-gcp-378519.iam.gserviceaccount.com"]
        sources {
          access_level = "*"
        }
      }
      ingress_to {
        operations {
          service_name = "dns.googleapis.com"
          method_selectors {
            method = "*"
          }
        }
      }
    }

    ingress_policies {
      title = "[INF-844] sailpoint@surescripts.com"
      ingress_from {
        identities = ["user:sailpoint@surescripts.com"]
        sources {
          access_level = "*"
        }
      }
      ingress_to {
        operations {
          service_name = "iam.googleapis.com"
          method_selectors {
            method = "*"
          }
        }
      }
    }

    ingress_policies {
      title = "[INF-840] Sailpoint AlloyDB"
      ingress_from {
        identities = ["serviceAccount:svc-sailpoint@prod-gcp-378519.iam.gserviceaccount.com",
                      "serviceAccount:svc-sailpoint@staging-gcp-378519.iam.gserviceaccount.com",
                      "serviceAccount:svc-sailpoint@systest-gcp-537851.iam.gserviceaccount.com",
                      "serviceAccount:svc-sailpoint@vaulted-circle-378519.iam.gserviceaccount.com"]
        sources {
          access_level = "*"
        }
      }
      ingress_to {
        operations {
          service_name = "alloydb.googleapis.com"
          method_selectors {
            method = "*"
          }
        }
      }
    }

  } # end of status block

  use_explicit_dry_run_spec = true
} # end of google_access_context_manager_service_perimeter


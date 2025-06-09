
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

    egress_policies {
      title = "[INF-837] Veeam Backup"
      egress_from {
        identities = ["serviceAccount:svc-veeam-prod-backup@prod-backup-378519.iam.gserviceaccount.com"]
      }
      egress_to {
        resources = ["*"]
        operations {
          service_name = "compute.googleapis.com"
          method_selectors {
            method = "*"
          }
        }
        operations {
          service_name = "pubsub.googleapis.com"
          method_selectors {
            method = "*"
          }
        }        
      }
    }










    egress_policies {
      title = "NetApp - Service Usage"
      egress_from {
        identities = ["serviceAccount:svc-atom-tenant-admin@netapp-us-c1-sde.iam.gserviceaccount.com"]
      }
      egress_to {
        resources = ["*"]
        operations {
          service_name = "serviceusage.googleapis.com"
          method_selectors {
            method = "*"
          }
        }       
      }
    }

    ingress_policies {
      title = "[INF-834] service-org-1041583873210-gcp-sa-logging"
      ingress_from {
        identities = ["serviceAccount:service-org-1041583873210@gcp-sa-logging.iam.gserviceaccount.com"]
        sources {
          access_level = "*"
        }
      }
      ingress_to {
        resources = ["*"]
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
        resources = ["*"]
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
        resources = ["*"]
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
        resources = ["*"]        
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
        resources = ["*"]        
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
        resources = ["*"]        
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
        resources = ["*"]        
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
        resources = ["*"]        
        operations {
          service_name = "alloydb.googleapis.com"
          method_selectors {
            method = "*"
          }
        }
      }
    }

    ingress_policies {
      title = "svc-cpi-test@vaulted-circle-378519.iam.gserviceaccount.com"
      ingress_from {
        identities = ["serviceAccount:svc-cpi-test@vaulted-circle-378519.iam.gserviceaccount.com"]
        sources {
          access_level = "*"
        }
      }
      ingress_to {
        resources = ["*"]        
        operations {
          service_name = "bigquery.googleapis.com" 
          method_selectors {
            method = "*"
          }
        }  
        operations {
          service_name = "composer.googleapis.com" 
          method_selectors {
            method = "*"
          }
        }        
      }
    }

    ingress_policies {
      title = "Compute Default Service Account Log Writing"
      ingress_from {
        identities = ["serviceAccount:244108982333-compute@developer.gserviceaccount.com",
                      "serviceAccount:290563624452-compute@developer.gserviceaccount.com",
                      "serviceAccount:306119004471-compute@developer.gserviceaccount.com",
                      "serviceAccount:681959470788-compute@developer.gserviceaccount.com",
                      "serviceAccount:787344780781-compute@developer.gserviceaccount.com",
                      "serviceAccount:940795332954-compute@developer.gserviceaccount.com"]
        sources {
          access_level = "*"
        }
      }
      ingress_to {
        resources = ["*"]        
        operations {
          service_name = "logging.googleapis.com" 
          method_selectors {
            method = "*"
          }
        }       
      }
    }

    ingress_policies {
      title = "[INF-843] Hadoopdash"
      ingress_from {
        identities = ["serviceAccount:hadoopdash-api@prod-gcp-378519.iam.gserviceaccount.com",
                      "serviceAccount:hadoopdash-api@vaulted-circle-378519.iam.gserviceaccount.com"]
        sources {
          access_level = "*"
        }
      }
      ingress_to {
        resources = ["*"]        
        operations {
          service_name = "composer.googleapis.com" 
          method_selectors {
            method = "*"
          }
        }       
      }
    }

    ingress_policies {
      title = "drproc-tp-sa@cloud-dataproc-producer.iam.gservice"
      ingress_from {
        identities = ["serviceAccount:drproc-tp-sa@cloud-dataproc-producer.iam.gserviceaccount.com"]
        sources {
          access_level = "*"
        }
      }
      ingress_to {
        resources = ["*"]        
        operations {
          service_name = "serviceusage.googleapis.com" 
          method_selectors {
            method = "*"
          }
        }       
      }
    }

    ingress_policies {
      title = "ansible-tower@proddr.iam.gserviceaccount.com"
      ingress_from {
        identities = ["serviceAccount:ansible-tower@proddr.iam.gserviceaccount.com"]
        sources {
          access_level = "*"
        }
      }
      ingress_to {
        resources = ["*"]        
        operations {
          service_name = "pubsub.googleapis.com" 
          method_selectors {
            method = "*"
          }
        }        
      }
    }

    ingress_policies {
      title = "[INF-849] Break Glass Access"
      ingress_from {
        identities = ["group:grp-org-owner@surescripts.com"]
        sources {
          access_level = "*"
        }
      }
      ingress_to {
        resources = ["*"]        
        operations {
          service_name = "*"
        }
      }
    }

   ingress_policies {
      title = "[INF-847] lro-asset-collector"
      ingress_from {
        identities = ["serviceAccount:lro-asset-collector@system.gserviceaccount.com"]
        sources {
          access_level = "*"
        }
      }
      ingress_to {
        resources = ["*"]        
        operations {
          service_name = "dataproc.googleapis.com"
          method_selectors {
            method = "*"
          }
        }
      }
    }

   ingress_policies {
      title = "[INF-848] spanner-infra-cmek-global cloudkms"
      ingress_from {
        identities = ["serviceAccount:spanner-infra-cmek-global@system.gserviceaccount.com"]
        sources {
          access_level = "*"
        }
      }
      ingress_to {
        resources = ["*"]        
        operations {
          service_name = "cloudkms.googleapis.com"
          method_selectors {
            method = "*"
          }
        }
      }
    }

    ingress_policies {
      title = "[INF-846] NetApp Networking"
      ingress_from {
        identities = ["serviceAccount:svc-sde-networking@netapp-us-c1-sde.iam.gserviceaccount.com"]
        sources {
          access_level = "*"
        }
      }
      ingress_to {
        resources = ["*"]        
        operations {
          service_name = "servicenetworking.googleapis.com"
          method_selectors {
            method = "*"
          }
        }
      }
    }

   ingress_policies {
      title = "Service Account So VPC-SC Logging Always Works"
      ingress_from {
        identities = ["serviceAccount:service-org-1041583873210@gcp-sa-logging.iam.gserviceaccount.com"]
        sources {
          access_level = "*"
        }
      }
      ingress_to {
        resources = ["*"]        
        operations {
          service_name = "*"
        }
      }
    }

   ingress_policies {
      title = "All Human Users"
      ingress_from {
        identities = ["group:aa-Dev-AllUsers-Temp@surescripts-dev.qa",
                      "group:aa-Prod-AllUsers-Temp@ext.surescripts.com",
                      "group:gcp-grp-all-surescripts-gcp-users@surescripts.com"]
        sources {
          access_level = "*"
        }
      }
      ingress_to {
        resources = ["*"]        
        operations {
          service_name = "*"
        }
      }
    }

    ingress_policies {
      title = "Telegraf PubSub Metric Retrieval"
      ingress_from {
        identities = ["serviceAccount:telegraf@prod-gcp-378519.iam.gserviceaccount.com"]
        sources {
          access_level = "*"
        }
      }
      ingress_to {
        resources = ["*"]        
        operations {
          service_name = "pubsub.googleapis.com"
          method_selectors {
            method = "*"
          }
        }
      }
    }

   ingress_policies {
      title = "CloudZero"
      ingress_from {
        identities = ["serviceAccount:cloudzero-601403c4-04c9-4b92-8@prod-billing-data-ingest.iam.gserviceaccount.com"]
        sources {
          access_level = "*"
        }
      }
      ingress_to {
        #
        #  NEED TO ADD projects/705515732372 AS A TARGET
        #
        resources = ["*"]        
        operations {
          service_name = "bigquery.googleapis.com"
          method_selectors {
            permission = "bigquery.tables.get"
          }
          method_selectors {
            permission = "bigquery.tables.getData"
          }          
        }
      }
    }

    ingress_policies {
      title = "NetApp CMEK Access"
      ingress_from {
        identities = ["serviceAccount:n-cmek-usce1-212304910690@netapp-cmek-prod.iam.gserviceaccount.com",
                      "serviceAccount:n-cmek-usce1-244108982333@netapp-cmek-prod.iam.gserviceaccount.com",
                      "serviceAccount:n-cmek-usce1-306119004471@netapp-cmek-prod.iam.gserviceaccount.com"]
        sources {
          access_level = "*"
        }
      }
      ingress_to {
        resources = ["*"]        
        operations {
          service_name = "cloudkms.googleapis.com"
          method_selectors {
            method = "*"
          }
        }
      }
    }

    ingress_policies {
      title = "NetApp Service Access"
      ingress_from {
        identities = ["serviceAccount:svc-atom-tenant-admin@netapp-us-c1-sde.iam.gserviceaccount.com"]
        sources {
          access_level = "*"
        }
      }
      ingress_to {
        resources = ["*"]        
        operations {
          service_name = "serviceusage.googleapis.com"
          method_selectors {
            method = "*"
          }
        }
      }
    }

  } # end of status block

  use_explicit_dry_run_spec = true
} # end of google_access_context_manager_service_perimeter


module "gcp_org_policy_v2_list" {
  source  = "terraform-google-modules/org-policy/google//modules/org_policy_v2"
  version = "~> 7.0"

  policy_root    = "organization"
  policy_root_id = "987000039256"
  constraint     = "compute.vmExternalIpAccess"
  policy_type    = "list"

  rules = [
    # Rule 1
    {
      enforcement = true
      allow = var.vms_with_public_ips
    }
  ]
}


terraform {
  backend "s3" {
    bucket               = "cqen-apps-sandbox-github-action-ressources-zp7"
    workspace_key_prefix = "environments"
    key                  = "projects/base/apps/signserver/terraform.tfstate"
    region               = "ca-central-1"
    profile              = "feature-cqen-v1-sandbox"  
  }
}
# This file configures the Terraform providers.

terraform {
  # This backend block is configured dynamically using the -backend-config flag
  # during 'terraform init'. This allows us to switch between environments.
  backend "gcs" {}
}

provider "google" {
  project = var.project_id
  region  = var.region
}
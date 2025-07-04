
# This configuration is used to create the GCS bucket that will store the
# Terraform state for all environments. It should be run once.

# Configure the Google Cloud provider
provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}

# Variable for the GCP Project ID
variable "gcp_project_id" {
  description = "The GCP project ID where the infrastructure will be deployed."
  type        = string
}

# Variable for the GCP Region
variable "gcp_region" {
  description = "The default GCP region for resources."
  type        = string
  default     = "us-central1" 
}

# Create a Cloud Storage bucket for 'dev' environment Terraform state
resource "google_storage_bucket" "dev_terraform_state" {
  name          = "${var.gcp_project_id}-tfstate-dev" # Unique bucket name
  location      = "US" # Choose a multi-regional or regional location based on your needs
  project       = var.gcp_project_id
  uniform_bucket_level_access = true # Recommended for security
  versioning {
    enabled = true # Enable versioning to keep a history of state files
  }
  lifecycle {
    prevent_destroy = false # Prevent accidental deletion of the bucket
  }
  labels = {
    environment = "dev"
    managed_by  = "terraform"
  }
  force_destroy = true
}

# Create a Cloud Storage bucket for 'uat' environment Terraform state
resource "google_storage_bucket" "uat_terraform_state" {
  name          = "${var.gcp_project_id}-tfstate-uat"
  location      = "US"
  project       = var.gcp_project_id
  uniform_bucket_level_access = true
  versioning {
    enabled = true
  }
  lifecycle {
    prevent_destroy = false
  }
  labels = {
    environment = "uat"
    managed_by  = "terraform"
  }
  force_destroy = true
}

# Create a Cloud Storage bucket for 'prod' environment Terraform state
resource "google_storage_bucket" "prod_terraform_state" {
  name          = "${var.gcp_project_id}-tfstate-prod"
  location      = "US"
  project       = var.gcp_project_id
  uniform_bucket_level_access = true
  force_destroy = true
  versioning {
    enabled = true
  }
  lifecycle {
    prevent_destroy = false
  }
  labels = {
    environment = "prod"
    managed_by  = "terraform"
  }
}

output "dev_bucket_name" {
  description = "Name of the development environment Terraform state bucket."
  value       = google_storage_bucket.dev_terraform_state.name
}

output "uat_bucket_name" {
  description = "Name of the UAT environment Terraform state bucket."
  value       = google_storage_bucket.uat_terraform_state.name
}

output "prod_bucket_name" {
  description = "Name of the production environment Terraform state bucket."
  value       = google_storage_bucket.prod_terraform_state.name
}

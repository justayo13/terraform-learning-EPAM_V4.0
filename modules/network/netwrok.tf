# Resource definitions for VPC and Subnets

resource "google_compute_network" "vpc" {
  project                 = var.project_id
  name                    = "${var.env}-vpc"
  auto_create_subnetworks = false
  routing_mode            = var.routing_mode
}

resource "google_compute_subnetwork" "subnet" {
  project                  = var.project_id
  name                     = "${var.env}-subnet-${var.region}"
  ip_cidr_range            = var.subnet_cidr
  region                   = var.region
  network                  = google_compute_network.vpc.id
  private_ip_google_access = var.private_ip_google_access
}
# Resource definitions for Firewall Rules

resource "google_compute_firewall" "allow_http" {
  project       = var.project_id
  name          = "${var.env}-allow-http"
  network       = var.network_name
  priority      = var.firewall_rule_priority
  source_ranges = var.http_source_ranges
  target_tags   = [var.web_server_tag]

  allow {
    protocol = "tcp"
    ports    = var.http_ports
  }
}

# Allow HTTPS traffic based on the provided ports and source ranges.
resource "google_compute_firewall" "allow_https" {
  project       = var.project_id
  name          = "${var.env}-allow-https"
  network       = var.network_name
  priority      = var.firewall_rule_priority
  source_ranges = var.https_source_ranges
  target_tags   = [var.web_server_tag]

  allow {
    protocol = "tcp"
    ports    = var.https_ports
  }
}


# Allow SSH traffic from a restricted range.
# Note: This rule does not use a target_tag by default, so it applies
# to all instances in the VPC that match the source range.
resource "google_compute_firewall" "allow_ssh" {
  project       = var.project_id
  name          = "${var.env}-allow-ssh"
  network       = var.network_name
  priority      = var.firewall_rule_priority
  source_ranges = var.ssh_source_ranges

  allow {
    protocol = "tcp"
    ports    = var.ssh_ports
  }
}
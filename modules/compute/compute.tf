# Resource definitions for Compute Engine

# Instance template for the web servers
resource "google_compute_instance_template" "web_server" {
  project      = var.project_id
  name_prefix  = "${var.env}-web-server-"
  machine_type = var.machine_type
  region       = var.region

  tags = [var.web_server_tag, var.env]

  disk {
    source_image = var.source_image
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network    = var.network_self_link
    subnetwork = var.subnet_self_link
    access_config {} # Assigns an ephemeral public IP
  }

  # Startup script to install Apache
  metadata_startup_script = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y apache2
    echo '<!doctype html><html><body><h1>Hello from ${var.env} environment!</h1></body></html>' | tee /var/www/html/index.html
    EOF

  lifecycle {
    create_before_destroy = true
  }
}

# Regional managed instance group
resource "google_compute_region_instance_group_manager" "web_servers" {
  project            = var.project_id
  name               = "${var.env}-mig"
  region             = var.region
  base_instance_name = "${var.env}-web"
  version {
    instance_template = google_compute_instance_template.web_server.id
  }
  target_size = var.instance_count
}
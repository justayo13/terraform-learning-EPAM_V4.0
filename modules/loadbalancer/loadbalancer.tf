# Resource definitions for Load Balancers, Backend Services, and Cloud Armor

# --- Load Balancer Components ---

# Health Check
resource "google_compute_health_check" "http_health_check" {
  project             = var.project_id
  name                = "${var.env}-http-health-check"
  check_interval_sec  = var.health_check_interval_sec
  timeout_sec         = var.health_check_timeout_sec
  healthy_threshold   = var.health_check_healthy_threshold
  unhealthy_threshold = var.health_check_unhealthy_threshold
  
  http_health_check {
    port         = var.health_check_port
    request_path = "/" 
  }
}

# Backend Service
resource "google_compute_backend_service" "web_backend" {
  project               = var.project_id
  name                  = "${var.env}-web-backend"
  protocol              = var.backend_protocol
  port_name             = var.backend_port_name
  load_balancing_scheme = "EXTERNAL"
  timeout_sec           = var.backend_timeout_sec
  health_checks         = [google_compute_health_check.http_health_check.id]
  security_policy       = google_compute_security_policy.armor_policy.self_link

  backend {
    group = var.instance_group
  }
}

# URL Map
resource "google_compute_url_map" "url_map" {
  project         = var.project_id
  name            = "${var.env}-url-map"
  default_service = google_compute_backend_service.web_backend.id
}

# Target HTTP Proxy
resource "google_compute_target_http_proxy" "http_proxy" {
  project = var.project_id
  name    = "${var.env}-http-proxy"
  url_map = google_compute_url_map.url_map.id
}

# Global Forwarding Rule (IP Address)
resource "google_compute_global_forwarding_rule" "forwarding_rule" {
  project                 = var.project_id
  name                    = "${var.env}-forwarding-rule"
  target                  = google_compute_target_http_proxy.http_proxy.id
  port_range              = var.forwarding_rule_port_range
  load_balancing_scheme   = "EXTERNAL"
}

# --- Cloud Armor Security Policy ---
resource "google_compute_security_policy" "armor_policy" {
  project     = var.project_id
  name        = "${var.env}-armor-policy"
  description = "Security policy for the ${var.env} load balancer"

  dynamic "rule" {
    for_each = var.armor_rules
    content {
      action      = rule.value.action
      priority    = rule.value.priority
      description = rule.value.description
      match {
        versioned_expr = rule.value.versioned_expr
        config {
          src_ip_ranges = rule.value.src_ip_ranges
        }
      }
    }
  }
}
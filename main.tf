# This is the root configuration that calls the reusable modules.
# The variables for each environment are passed in via .tfvars files.

module "network" {
  source                     = "./modules/network"
  project_id                 = var.project_id
  env                        = var.env
  region                     = var.region
  subnet_cidr                = var.subnet_cidr
  routing_mode               = var.routing_mode
  private_ip_google_access   = var.private_ip_google_access
}

module "firewall" {
  source                = "./modules/firewall"
  project_id            = var.project_id
  env                   = var.env
  network_name          = module.network.network_name
  web_server_tag        = var.web_server_tag
  firewall_rule_priority= var.firewall_rule_priority
  ssh_source_ranges     = var.ssh_source_ranges
  http_source_ranges    = var.http_source_ranges
  https_source_ranges   = var.https_source_ranges
  http_ports            = var.http_ports
  https_ports           = var.https_ports
  ssh_ports             = var.ssh_ports
}

module "compute" {
  source            = "./modules/compute"
  project_id        = var.project_id
  env               = var.env
  region            = var.region
  machine_type      = var.machine_type
  instance_count    = var.instance_count
  network_self_link = module.network.network_self_link
  subnet_self_link  = module.network.subnet_self_link
  web_server_tag    = var.web_server_tag
  source_image      = var.source_image
}

module "loadbalancer" {
  source                           = "./modules/loadbalancer"
  project_id                       = var.project_id
  env                              = var.env
  instance_group                   = module.compute.instance_group
  armor_rules                      = var.armor_rules
  forwarding_rule_port_range       = var.forwarding_rule_port_range
  health_check_port                = var.health_check_port
  health_check_interval_sec        = var.health_check_interval_sec
  health_check_timeout_sec         = var.health_check_timeout_sec
  health_check_healthy_threshold   = var.health_check_healthy_threshold
  health_check_unhealthy_threshold = var.health_check_unhealthy_threshold
  backend_protocol                 = var.backend_protocol
  backend_port_name                = var.backend_port_name
  backend_timeout_sec              = var.backend_timeout_sec
}

# --- Root Outputs ---
output "load_balancer_ip" {
  description = "The public IP address of the load balancer."
  value       = module.loadbalancer.lb_ip_address
}
# These variables are the inputs for the root module.
# Their values will be provided by the .tfvars files for each environment.

# This is the single source of truth for all configurable variables and their
# default values. Environment-specific .tfvars files will override these.

# --- General ---
variable "project_id" {
  description = "The GCP project ID. This has no default and MUST be set in a .tfvars file."
  type        = string
}

variable "env" {
  description = "The environment name (e.g., dev, uat, prod). MUST be set in a .tfvars file."
  type        = string
}

variable "region" {
  description = "The primary GCP region for the resources. MUST be set in a .tfvars file."
  type        = string
}

# --- Networking ---
variable "subnet_cidr" {
  description = "The CIDR block for the environment's subnet. MUST be set in a .tfvars file."
  type        = string
}

variable "routing_mode" {
  description = "The routing mode for the VPC."
  type        = string
  default     = "REGIONAL"
}

variable "private_ip_google_access" {
  description = "Allows VMs in this subnet to access Google services without external IPs."
  type        = bool
  default     = true
}

# --- Firewall ---
variable "network_name" {
  description = "The name of the VPC network."
  type        = string
}

variable "firewall_rule_priority" {
  description = "The priority for the firewall rules."
  type        = number
  default     = 1000
}

variable "ssh_source_ranges" {
  description = "A list of CIDR blocks to allow SSH from. MUST be set in a .tfvars file."
  type        = list(string)
}

variable "http_source_ranges" {
  description = "A list of CIDR blocks to allow HTTP from."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "https_source_ranges" {
  description = "A list of CIDR blocks to allow HTTPS from."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "http_ports" {
  description = "List of ports to open for HTTP traffic."
  type        = list(string)
  default     = ["80"]
}

variable "https_ports" {
  description = "List of ports to open for HTTPS traffic."
  type        = list(string)
  default     = ["443"]
}

variable "ssh_ports" {
  description = "List of ports to open for SSH traffic."
  type        = list(string)
  default     = ["22"]
}

# --- Compute ---
variable "web_server_tag" {
  description = "The network tag to apply to web servers for firewall rules."
  type        = string
  default     = "web-server"
}
variable "machine_type" {
  description = "The machine type for the instances."
  type        = string
  default     = "e2-micro"
}

variable "source_image" {
  description = "The source image for the boot disk."
  type        = string
  default     = "debian-cloud/debian-11"
}

variable "instance_count" {
  description = "The number of instances to create."
  type        = number
  default     = 2
}

variable "network_self_link" {
  description = "The self_link of the VPC network."
  type        = string
}

variable "subnet_self_link" {
  description = "The self_link of the subnet."
  type        = string
}

# --- Load Balancer & Cloud Armor ---
variable "instance_group" {
  description = "The instance group to attach to the backend service."
  type        = string
}

variable "forwarding_rule_port_range" {
  description = "Port range for the Load Balancer forwarding rule."
  type        = string
  default     = "80"
}

variable "armor_rules" {
  description = "A list of objects defining the Cloud Armor security policy rules."
  type = list(object({
    action         = string
    priority       = number
    description    = string
    versioned_expr = string
    src_ip_ranges  = list(string)
  }))
  default = [
    {
      action         = "allow"
      priority       = 2147483647
      description    = "Default allow all rule"
      versioned_expr = "SRC_IPS_V1"
      src_ip_ranges  = ["*"]
    }
  ]
}

variable "health_check_port" {
  description = "The port used for the health check."
  type        = number
  default     = 80
}

variable "health_check_interval_sec" {
  description = "How often (in seconds) to send a health check."
  type        = number
  default     = 5
}

variable "health_check_timeout_sec" {
  description = "How long (in seconds) to wait before claiming failure."
  type        = number
  default     = 5
}

variable "health_check_healthy_threshold" {
  description = "A so-far unhealthy instance will be marked healthy after this many consecutive successes."
  type        = number
  default     = 2
}

variable "health_check_unhealthy_threshold" {
  description = "A so-far healthy instance will be marked unhealthy after this many consecutive failures."
  type        = number
  default     = 2
}

variable "backend_protocol" {
  description = "The protocol for the backend service."
  type        = string
  default     = "HTTP"
}

variable "backend_port_name" {
  description = "The name of the port on the backend service."
  type        = string
  default     = "http"
}

variable "backend_timeout_sec" {
  description = "Timeout for the backend service."
  type        = number
  default     = 30
}
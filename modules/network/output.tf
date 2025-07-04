# Output Network module
output "network_name" {
  description = "The name of the VPC network."
  value       = google_compute_network.vpc.name
}

output "network_self_link" {
  description = "The self_link of the VPC network."
  value       = google_compute_network.vpc.self_link
}

output "subnet_name" {
  description = "The name of the subnet."
  value       = google_compute_subnetwork.subnet.name
}

output "subnet_self_link" {
  description = "The self_link of the subnet."
  value       = google_compute_subnetwork.subnet.self_link
}
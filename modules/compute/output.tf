# Output Compute module

output "instance_group" {
  description = "The regional managed instance group."
  value       = google_compute_region_instance_group_manager.web_servers.instance_group
}

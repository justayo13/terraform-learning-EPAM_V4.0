# Output Load Balancer module

output "lb_ip_address" {
  description = "The IP address of the load balancer."
  value       = google_compute_global_forwarding_rule.forwarding_rule.ip_address
}
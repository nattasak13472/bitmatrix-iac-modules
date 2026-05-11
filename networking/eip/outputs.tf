output "eip_allocation_ids" {
  description = "List of allocation IDs of the EIPs"
  value       = aws_eip.nat[*].id
}

output "eip_public_ips" {
  description = "List of public IPs of the EIPs"
  value       = aws_eip.nat[*].public_ip
}

output "eip_allocation_id" {
  description = "List of allocation IDs of the EIPs"
  value       = aws_eip.nat.id
}

output "eip_public_ip" {
  description = "List of public IPs of the EIPs"
  value       = aws_eip.nat.public_ip
}

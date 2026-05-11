output "nat_gateway_ids" {
  description = "List of IDs of the NAT Gateways"
  value       = aws_nat_gateway.this[*].id
}

output "nat_gateway_public_ips" {
  description = "List of public IPs of the NAT Gateways"
  value       = aws_nat_gateway.this[*].public_ip
}

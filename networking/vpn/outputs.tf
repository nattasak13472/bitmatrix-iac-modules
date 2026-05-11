output "client_vpn_endpoint_id" {
  description = "The ID of the Client VPN endpoint"
  value       = try(aws_ec2_client_vpn_endpoint.this[0].id, null)
}

output "client_vpn_dns_name" {
  description = "The DNS name of the Client VPN endpoint"
  value       = try(aws_ec2_client_vpn_endpoint.this[0].dns_name, null)
}

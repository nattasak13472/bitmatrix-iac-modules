output "zone_id" {
  description = "The ID of the Route53 zone"
  value       = aws_route53_zone.this.zone_id
}

output "name_servers" {
  description = "The name servers for the Route53 zone"
  value       = aws_route53_zone.this.name_servers
}

output "domain_name" {
  description = "The domain name of the Route53 zone"
  value       = aws_route53_zone.this.name
}

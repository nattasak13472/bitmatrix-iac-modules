output "certificate_arn" {
  description = "The ARN of the certificate"
  value       = aws_acm_certificate.this.arn
}

output "certificate_domain_name" {
  description = "The domain name for which the certificate is issued"
  value       = aws_acm_certificate.this.domain_name
}

output "domain_validation_options" {
  description = "The domain validation options for the certificate"
  value       = aws_acm_certificate.this.domain_validation_options
}

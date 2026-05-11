output "arn" {
  description = "The ARN assigned by AWS for this provider"
  value       = aws_iam_saml_provider.this.arn
}

output "name" {
  description = "The name of the SAML provider"
  value       = aws_iam_saml_provider.this.name
}

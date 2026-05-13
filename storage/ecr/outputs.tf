output "repository_arn" {
  description = "Full ARN of the repository"
  value       = aws_ecr_repository.this.arn
}

output "repository_url" {
  description = "The URL of the repository (used for docker push/pull)"
  value       = aws_ecr_repository.this.repository_url
}

output "resource_name" {
  description = "The name of the repository"
  value       = aws_ecr_repository.this.name
}

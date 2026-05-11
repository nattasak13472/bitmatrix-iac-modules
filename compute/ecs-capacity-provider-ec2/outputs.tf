output "asg_name" {
  description = "The name of the Auto Scaling Group"
  value       = aws_autoscaling_group.this.name
}

output "capacity_provider_name" {
  description = "The name of the capacity provider"
  value       = aws_ecs_capacity_provider.this.name
}

output "capacity_provider_arn" {
  description = "The ARN of the capacity provider"
  value       = aws_ecs_capacity_provider.this.arn
}

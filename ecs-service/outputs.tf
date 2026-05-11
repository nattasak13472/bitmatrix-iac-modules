output "service_id" {
  description = "The ARN that identifies the service"
  value       = aws_ecs_service.this.id
}

output "service_name" {
  description = "The name of the service"
  value       = aws_ecs_service.this.name
}

output "task_definition_arn" {
  description = "Full ARN of the Task Definition (including both family and revision)"
  value       = aws_ecs_task_definition.this.arn
}

output "task_definition_family" {
  description = "The family of the Task Definition"
  value       = aws_ecs_task_definition.this.family
}

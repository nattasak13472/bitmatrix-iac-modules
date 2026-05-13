resource "aws_ecs_cluster" "this" {
  name = "${var.project}-${var.environment}-${var.resource_name}"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = var.common_tags
}

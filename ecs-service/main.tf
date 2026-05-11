resource "aws_ecs_task_definition" "this" {
  family                   = "${var.project}-${var.environment}-${var.name}"
  container_definitions    = var.container_definitions
  network_mode             = var.network_mode
  requires_compatibilities = ["EC2"]
  cpu                      = var.cpu
  memory                   = var.memory

  execution_role_arn = var.execution_role_arn
  task_role_arn      = var.task_role_arn

  dynamic "volume" {
    for_each = var.volumes
    content {
      name      = volume.value.name
      host_path = volume.value.host_path
    }
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project}-${var.environment}-${var.name}-task"
    }
  )
}


resource "aws_ecs_service" "this" {
  name                = "${var.project}-${var.environment}-${var.name}-svc"
  cluster             = var.cluster_id
  task_definition     = aws_ecs_task_definition.this.arn
  scheduling_strategy = var.scheduling_strategy

  # Desired count is ignored for DAEMON strategy
  desired_count = var.scheduling_strategy == "DAEMON" ? null : var.desired_count

  # Optional Load Balancer Block
  dynamic "load_balancer" {
    for_each = var.target_group_arn != null ? [1] : []
    content {
      target_group_arn = var.target_group_arn
      container_name   = var.container_name
      container_port   = var.container_port
    }
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project}-${var.environment}-${var.name}-svc"
    }
  )

  lifecycle {
    ignore_changes = [desired_count] # Allow ASG/Capacity Providers to manage scaling
  }
}

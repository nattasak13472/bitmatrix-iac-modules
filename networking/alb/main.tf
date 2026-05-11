resource "aws_lb" "this" {
  name               = "${var.project}-${var.environment}-${var.alb_name}"
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = var.security_groups
  subnets            = var.subnet_ids

  enable_deletion_protection = false # Usually false for dev/nonprod, set to true for prod in reality

  tags = merge(
    var.common_tags,
    {
      Name        = "${var.project}-${var.environment}-${var.alb_name}"
      Environment = var.environment
    }
  )
}

# Application Load Balancer (ALB) Module

This module manages an AWS Application Load Balancer. It is designed to be highly flexible, supporting both public-facing applications and private microservices.

## 🚀 Example Usage

### 1. Internet-Facing ALB (Public Application)
Use this for applications that are directly accessible from the internet.

```hcl
module "public_alb" {
  source   = "../../networking/alb"
  internal = false # Public
  
  project         = "bitmatrix"
  environment     = "nonprod"
  resource_name        = "public-app"
  security_groups = [module.alb_sg.id]
  subnet_ids      = module.vpc.public_subnets
}

# Example Listener & Target Group for ECS
resource "aws_lb_target_group" "ecs_app" {
  name        = "ecs-public-app-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "ip" # Required for Fargate
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = module.public_alb.alb_arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_app.arn
  }
}
```

### 2. Internal ALB (Private Microservice / Behind CloudFront)
Use this for microservices that should only be accessible within the VPC or via CloudFront.

```hcl
module "private_alb" {
  source   = "../../networking/alb"
  internal = true # Private
  
  project         = "bitmatrix"
  environment     = "nonprod"
  resource_name        = "internal-api"
  security_groups = [module.internal_sg.id]
  subnet_ids      = module.vpc.private_subnets
}
```

## 🏗 ECS Integration Note
When integrating with an **ECS Service**, ensure that:
1.  **Target Type**: Set `target_type = "ip"` in your target group if using Fargate.
2.  **Health Checks**: Configure health checks in the target group to match your application's health endpoint (e.g., `/health`).
3.  **Security Groups**: The ALB security group must allow outbound traffic to the ECS tasks on the container port.

# ECS Service Module

This module manages Amazon Elastic Container Service (ECS) Task Definitions and Services. It is highly flexible and supports standard web microservices as well as infrastructure agents.

## 🚀 Example Usage

### 1. Microservice Use Case (REPLICA with ALB)
This is the standard use case for a web application (e.g., Laravel, Golang, Vue.js). It demonstrates how to connect the ECS Service to our ALB module using a Target Group.

```hcl
# 1. The Load Balancer
module "app_alb" {
  source          = "../../networking/alb"
  project         = "bitmatrix"
  environment     = "prod"
  alb_name        = "public-api"
  internal        = false
  security_groups = [module.alb_sg.id]
  subnet_ids      = module.vpc.public_subnets
}

# 2. The Target Group (The Glue)
resource "aws_lb_target_group" "laravel_api" {
  name        = "laravel-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "instance" # Or "ip" if using awsvpc network mode
  
  health_check {
    path = "/health"
  }
}

# 3. The ECS Service
module "laravel_app" {
  source = "../../ecs-service"

  project     = "bitmatrix"
  environment = "prod"
  name        = "laravel-api"
  cluster_id  = module.ecs_cluster.cluster_id

  # Scheduling Strategy (Default is REPLICA)
  desired_count = 3
  
  # IAM Setup
  execution_role_arn = module.ecs_execution_role.arn
  task_role_arn      = module.ecs_task_role.arn

  # Load Balancer Attachment
  target_group_arn = aws_lb_target_group.laravel_api.arn
  container_name   = "nginx"
  container_port   = 80

  # Container Definitions (JSON)
  container_definitions = jsonencode([
    {
      name      = "nginx"
      image     = "nginx:alpine"
      essential = true
      portMappings = [
        { containerPort = 80 }
      ]
    },
    {
      name      = "php-fpm"
      image     = "laravel-app:latest"
      essential = true
    }
  ])
}
```

### 2. High-Security Edge Architecture (CloudFront -> Internal ALB -> ECS)
This is the recommended architecture for production web applications. The ALB is completely private (internal), and traffic is routed exclusively through CloudFront for edge caching and DDoS protection.

```hcl
# 1. CloudFront Edge Distribution
module "cdn" {
  source = "../../networking/cloudfront"
  
  project             = "bitmatrix"
  environment         = "prod"
  domain_name         = "api.bitmatrix.com"
  
  # Point CloudFront to the internal ALB DNS
  origin_domain_name  = module.internal_alb.alb_dns_name
  origin_id           = "InternalApiALB"
  
  acm_certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/..."
}

# 2. The Internal Load Balancer
module "internal_alb" {
  source          = "../../networking/alb"
  project         = "bitmatrix"
  environment     = "prod"
  alb_name        = "private-api"
  internal        = true # KEY: Not accessible from the public internet
  security_groups = [module.internal_alb_sg.id]
  subnet_ids      = module.vpc.private_subnets
}

# 3. The Target Group & Listener (The Glue)
resource "aws_lb_target_group" "api_tg" {
  name        = "api-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "instance"
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = module.internal_alb.alb_arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api_tg.arn
  }
}

# 4. The ECS Service
module "secure_api_service" {
  source = "../../ecs-service"

  project     = "bitmatrix"
  environment = "prod"
  name        = "secure-api"
  cluster_id  = module.ecs_cluster.cluster_id
  
  target_group_arn   = aws_lb_target_group.api_tg.arn
  container_name     = "app"
  container_port     = 80
  execution_role_arn = module.ecs_execution_role.arn
  
  container_definitions = jsonencode([
    {
      name  = "app"
      image = "my-secure-api:latest"
      essential = true
      portMappings = [{ containerPort = 80 }]
    }
  ])
}
```

### 3. Daemon Use Case (Agent Monitoring)

This use case is for infrastructure agents like Wazuh, Grafana Promtail, or Loki. It uses the `DAEMON` scheduling strategy, which automatically runs exactly one instance of the container on *every* active EC2 instance in your cluster.

```hcl
module "wazuh_agent" {
  source = "../../ecs-service"

  project     = "bitmatrix"
  environment = "prod"
  name        = "wazuh-agent"
  cluster_id  = module.ecs_cluster.cluster_id

  # Scheduling Strategy
  scheduling_strategy = "DAEMON"
  # Note: desired_count is ignored for DAEMON services

  # IAM Setup
  execution_role_arn = module.ecs_execution_role.arn
  task_role_arn      = module.ecs_task_role.arn

  # Container Definitions
  container_definitions = jsonencode([
    {
      name      = "wazuh-agent"
      image     = "wazuh/wazuh-agent:latest"
      essential = true
      environment = [
        { name = "WAZUH_MANAGER", value = "10.0.0.50" }
      ]
      # High privileges often required for security monitoring daemons
      privileged = true 
    }
  ])
}
```

## 🏗 Key Features
*   **Flexible Scheduling**: Native support for both `REPLICA` (standard apps) and `DAEMON` (agents/monitoring) strategies.
*   **Dynamic Load Balancing**: The `load_balancer` block is automatically created only if you provide a `target_group_arn`.
*   **Lifecycle Management**: `desired_count` is ignored in the lifecycle configuration, allowing your Auto Scaling Group or external CI/CD pipelines to manage scaling without Terraform reversing the changes.
*   **Decoupled IAM**: You maintain control over your security by providing the IAM roles directly.

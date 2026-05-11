# ECS EC2 Capacity Provider Module

This module manages the compute resources (Launch Template, ASG, and Capacity Provider) for an ECS cluster using the EC2 Launch Type. It is designed to be used in conjunction with the `ecs-cluster` module.

## 🚀 Example Usage

This example shows how to create a cluster and attach a Capacity Provider to it.

```hcl
# 1. Create the Cluster
module "my_cluster" {
  source       = "../../compute/ecs-cluster"
  project      = "bitmatrix"
  environment  = "nonprod"
  cluster_name = "app-cluster"
}

# 2. Setup the IAM Instance Profile (using the iam-role module)
module "ecs_node_role" {
  source    = "../../security/iam-role"
  role_name = "ecs-node-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
  ]
}

resource "aws_iam_instance_profile" "ecs_node_profile" {
  name = "ecs-node-profile"
  role = module.ecs_node_role.name
}

# 3. Create the Capacity Provider
module "on_demand_compute" {
  source = "../../compute/ecs-capacity-provider-ec2"

  project      = "bitmatrix"
  environment  = "nonprod"
  name_suffix  = "on-demand"
  cluster_name = module.my_cluster.cluster_name
  
  # Compute Config
  instance_type             = "t3.medium"
  ami_id                    = "ami-0123456789abcdef0" # ECS Optimized AMI
  subnet_ids                = module.vpc.private_subnets
  security_group_ids        = [module.ecs_sg.id]
  iam_instance_profile_name = aws_iam_instance_profile.ecs_node_profile.name

  # Scaling
  min_size         = 1
  max_size         = 10
  desired_capacity = 2
}
```

## 🏗 Key Features
*   **Decoupled IAM**: You provide the IAM instance profile, allowing for centralized security management.
*   **Automatic Scaling**: Includes an ECS Capacity Provider with managed scaling enabled (target capacity 80%).
*   **Custom Bootstrapping**: Use the `additional_user_data` variable to run scripts (e.g., installing agents) during node startup.

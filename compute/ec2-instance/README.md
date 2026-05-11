# EC2 Instance Module

This module manages a standalone AWS EC2 instance. It is ideal for persistent "pet" servers or specialized workloads such as GitLab Runners, Monitoring nodes (Grafana/Loki), or Bastion hosts.

## 🚀 Example Usage

### 1. GitLab Runner
Configured with extra disk space for Docker images and a t3.medium instance type.

```hcl
module "gitlab_runner" {
  source = "../../compute/ec2-instance"

  project       = "bitmatrix"
  environment   = "nonprod"
  instance_name = "gitlab-runner-01"
  ami_id        = "ami-0123456789abcdef0" # Ubuntu 22.04
  instance_type = "t3.medium"
  subnet_id     = module.vpc.private_subnets[0]
  vpc_security_group_ids = [module.runner_sg.id]

  root_volume_size = 50 # GB
  
  user_data = <<-EOT
    #!/bin/bash
    # Commands to install Docker and GitLab Runner
  EOT
}
```

### 2. Monitoring Node (Grafana & Loki)
Configured with a larger `gp3` volume for high-performance log indexing.

```hcl
module "monitoring_node" {
  source = "../../compute/ec2-instance"

  project       = "bitmatrix"
  environment   = "nonprod"
  instance_name = "monitoring-stack"
  ami_id        = "ami-0123456789abcdef0"
  instance_type = "t3.large" 
  subnet_id     = module.vpc.private_subnets[1]
  vpc_security_group_ids = [module.monitoring_sg.id]

  root_volume_size = 100
  root_volume_type = "gp3"
}
```

## 🏗 Key Features
*   **Encrypted Storage**: The root EBS volume is automatically encrypted.
*   **Safety Lifecycle**: Uses `ignore_changes = [ami]` to prevent server replacement if the source AMI is updated in your account.
*   **Tagging**: Follows the standard tagging convention for easy cost allocation.

## 📋 Prerequisites
*   An existing VPC and Subnet.
*   A Security Group defining the necessary ingress/egress rules for your service.

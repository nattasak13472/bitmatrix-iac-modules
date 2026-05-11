# IAM Role Module

This module manages AWS IAM roles and their policy attachments. It supports both managed policies and inline policies.

## 🚀 Example Usage

### 1. ECS EC2 Node Role
This role is required for EC2 instances to register as container instances in an ECS cluster.

```hcl
module "ecs_node_role" {
  source    = "../../security/iam-role"
  role_name = "ecs-container-instance-role"

  # Trust Policy (Who can assume this role?)
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  # Managed Policies (Standard AWS permissions)
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore" # Optional: For Session Manager access
  ]
}
```

### 2. SAML Federation Role (Google SSO)
This role is intended for users who authenticate via Google SSO and need to assume a role in AWS.

```hcl
module "developer_role" {
  source    = "../../security/iam-role"
  role_name = "google-sso-developer"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithSAML"
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::123456789012:saml-provider/GoogleSSO"
        }
        Condition = {
          StringEquals = {
            "SAML:aud" = "https://signin.aws.amazon.com/saml"
          }
        }
      }
    ]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/ReadOnlyAccess"
  ]
}
```

## 🏗 Key Features
*   **Decoupled Attachments**: Uses `aws_iam_role_policy_attachment` for safer policy management.
*   **Inline Policies**: Supports a map of custom inline policies for fine-grained control.
*   **Lifecycle**: Designed to be modular and reusable across different compute and security stacks.

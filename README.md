# AWS Infrastructure Modules Library

This repository contains versioned, reusable Terraform modules. These are the "Blueprints" used to ensure consistency across all AWS accounts and regions.

## 🛠 Tech Stack
- **Terraform:** 1.5.7
- **AWS Provider:** ~> 6.0
- **Documentation:** [terraform-docs](https://github.com/terraform-docs/terraform-docs)

## 📂 Module Catalog

| Category / Module | Description | Key Sub-Modules & Features |
| :--- | :--- | :--- |
| **`networking/`** | Connectivity & Edge | `alb` (Public/Internal), `cloudfront` (CDN Edge), `vpn` (SAML Federation), `security_group` |
| **`compute/`** | Servers & Orchestration | `ecs-cluster`, `ecs-capacity-provider-ec2` (ASG/Spot/OnDemand), `ec2-instance` (GitLab Runners) |
| **`ecs-service/`** | App Deployment | Microservice (`REPLICA`) & Agent (`DAEMON`) scheduling, Target Group Binding, Shared Volumes |
| **`database/`** | Data Storage | `aurora-postgresql` (Global Clusters for DR, Automated Secrets Manager integration) |
| **`security/`** | Identity & Encryption | `kms` (Crypto-Shredding), `secrets-manager` (Shell & Fill), `iam-role`, `iam-saml-provider`, `acm` |
| **`storage/`** | Persistence | `s3` (Lifecycle/Encryption), `ecr` (Auto-Cleanup/Scanning), `ebs` (Persistent Volumes) |

## 🚀 Usage
Do not reference modules using local paths. Always use Git tags:

```hcl
module "vpc" {
  source = "git::[https://gitlab.com/your-org/iac-modules.git//networking?ref=v1.0.0](https://gitlab.com/your-org/iac-modules.git//networking?ref=v1.0.0)"
  # ... inputs
}
```

## Development Rules
- **No Hardcoding:** All environment-specific values must be variables.
- **Tagging:** Follow Semantic Versioning. Create a Git Tag (e.g., v1.2.3) for every production-ready change.
- **Validation:** Run `terraform validate` and `tflint` before pushing.# bitmatrix-iac-modules

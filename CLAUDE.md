# 🛠️ bitmatrix-iac: Development & Contribution Guide

This guide outlines the architectural standards and development workflows for the **Bitmatrix Infrastructure as Code (IaC)** ecosystem.

---

## 🏗️ Core Design Principles

All modules must adhere to the following standards to ensure scalability and compliance.

### 1. Zero Hardcoding
- Every value that can change between `nonprod` and `prod` **must** be parameterized.
- Use `variables.tf` for inputs and provide sensible defaults only for non-critical values.
- **Standalone Sub-Modules:** Each sub-module (e.g., in `networking/`) must maintain its own `providers.tf` and `locals.tf` to remain independently deployable.

### 2. High Availability by Default
- **Networking:** Mandatory support for 3 Availability Zones (AZs).
- **Compute:** ECS on EC2 must utilize Auto Scaling Groups across all 3 AZs.
- **Data:** Aurora modules must support `aws_rds_global_cluster` for seamless Thailand-to-Singapore replication.

### 3. Security First
- **KMS:** Every stateful resource (S3, RDS, ElastiCache) must accept a `kms_key_id`.
- **Crypto-Shredding:** Modules must implement dedicated KMS keys per service to facilitate granular data destruction.
- **Public Access:** Explicit `public_access_block` is required for all S3 and Database resources.

### 4. Tagging Strategy
All modules must accept a `map(string)` called `common_tags`. 
**Standard Tags:** `Project`, `ManagedBy`, `ModuleSource`, `Compliance`.

---

## 📂 Module Specifications

### 🌏 `networking/`
- **Architecture:** Standalone sub-modules for granular provisioning.
- **Components:** `vpc/`, `subnets/`, `internet_gateway/`, `eip/`, `nat_gateway/`, `route_table/`, `vpn/`.
- **Dependency Flow:** Components are chained via input variables (e.g., `subnets` requires `vpc_id`).
- **Provisioning Order:** VPC → Subnets → IGW → EIP → NAT GW → Route Table → VPN.
- **AI Agent Guidance:** When modifying networking, ensure each sub-module remains independent and exposes necessary outputs for downstream components.

### ⚡ `compute/`
- **Optimization:** EC2 Launch Type (M5/C5 classes) tuned for 10k+ concurrent users.
- **Load Balancing:** Dual support for Internet-facing (Public) and Internal (Private) ALBs.

### 💾 `database/`
- **Scale:** Engineered for 20TB+ PostgreSQL datasets.
- **Performance:** `engine_mode = "provisioned"` with `iopt8` (I/O Optimized) storage class.
- **Cache:** ElastiCache Redis with optional cluster mode toggles.

---

## 🤖 AI Agent Instructions (Antigravity)

When generating code or suggesting changes for this repository, strictly adhere to the following architectural patterns:

### 1. Architectural Patterns
- **IAM Decoupling:** Compute (ECS) and Storage modules must **never** create their own IAM roles. They must accept `role_arn` variables to ensure IAM is centrally managed by the `security/iam-role` module.
- **ALB & Target Group Separation:** The `networking/alb` module only provisions the Load Balancer. The `aws_lb_target_group` acts as the "glue" and must be provisioned at the implementation layer to connect ALBs to ECS Services.
- **Storage Defaults (S3/ECR):** All storage modules must implement "Security-First" defaults: explicit public access blocks, mandatory server-side encryption (KMS or AES256), and automated lifecycle policies to optimize costs.
- **Scaling Hand-offs:** Any resource parameter managed by an external scaler (e.g., ECS `desired_count` or ASG `desired_capacity`) must be wrapped in a `lifecycle { ignore_changes = [...] }` block.

### 2. Output & Variable Standards
- **Dependency Map:** Ensure `outputs.tf` always includes the `arn` and `id` of the primary resource.
- **Cross-Region Logic:** Always expose the `global_cluster_identifier` for Aurora to allow `iac-provisioning` to link secondary regions.
- **Naming Convention:** Strictly follow `[project]-[env]-[service]-[region]` formatting (or omit region for global/standard resources).

---

## 🧪 Quality Control (QC)

Before committing any changes, run the following validation suite:

| Tool | Command | Description |
| :--- | :--- | :--- |
| **Terraform** | `terraform fmt -recursive` | Standardizes code formatting |
| **Terraform** | `terraform validate` | Checks for syntax and logic errors |
| **TFLint** | `tflint` | Catches cloud-specific best practice violations |
| **Tfsec** | `tfsec .` | Scans for security vulnerabilities and exposures |
| **Trivy** | `trivy iac scan .` | Scans for security vulnerabilities and exposures |

---

## 🛠 Tech Stack & Versions
- **Terraform:** `1.5.7`
- **AWS Provider:** `~> 6.0` (Required for native `ap-southeast-7` support)
- **Encryption:** AES-256 (via KMS)
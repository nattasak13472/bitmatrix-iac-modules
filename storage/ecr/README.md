# ECR Module

This module manages Amazon Elastic Container Registry (ECR) repositories. It is designed with a **"Security-First"** approach, defaulting to immutable tags and continuous vulnerability scanning. It also automatically implements lifecycle policies to optimize storage costs.

## 🚀 Example Usage

### 1. Standard Production Repository
Use this for standard microservices (like Laravel, Golang, Vue). It prevents tag overwrites and keeps the last 30 deployments to save money.

```hcl
module "laravel_app_repo" {
  source = "../../storage/ecr"

  project         = "bitmatrix"
  environment     = "prod"
  resource_name = "laravel-api"
  
  # Defaults applied:
  # - image_tag_mutability = "IMMUTABLE"
  # - scan_on_push = true
  # - keep_last_n_images = 30
}
```

### 2. High-Security Encrypted Repository
Use this if your container images contain highly sensitive intellectual property or baked-in secrets.

```hcl
# 1. Create a dedicated KMS key
module "ecr_kms" {
  source      = "../../security/kms"
  project     = "bitmatrix"
  environment = "prod"
  alias_name  = "ecr-encryption-key"
}

# 2. Create the ECR Repo
module "secure_auth_repo" {
  source = "../../storage/ecr"

  project         = "bitmatrix"
  environment     = "prod"
  resource_name = "auth-service"
  
  kms_key_arn = module.ecr_kms.key_arn
}
```

### 3. Development Repository (Mutable Tags)
Use this only in lower environments (`dev`/`qa`) where developers might push to the `latest` tag repeatedly without bumping semantic versions.

```hcl
module "dev_sandbox_repo" {
  source = "../../storage/ecr"

  project         = "bitmatrix"
  environment     = "dev"
  resource_name = "sandbox-api"
  
  image_tag_mutability = "MUTABLE" # Allows overwriting tags like 'latest'
  keep_last_n_images   = 5         # Aggressively delete old images in dev
}
```

## 🏗 Key Features
*   **Immutable Tags by Default**: Prevents a critical class of production bugs where an image tag (like `v1.2`) is accidentally overwritten with bad code.
*   **Vulnerability Scanning**: `scan_on_push` is enabled by default to immediately alert you if a pushed image contains known CVEs.
*   **Automatic Cost Optimization**: A built-in lifecycle policy automatically deletes untagged images after 14 days and retains only the last `N` tagged images (default 30), ensuring your AWS bill doesn't grow infinitely over time.

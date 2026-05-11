# S3 Storage Module

This module manages Amazon S3 buckets. It is designed with a **"Security-First"** approach, defaulting to blocking all public access and enabling server-side encryption out of the box.

## 🚀 Example Usage

### 1. Standard Secure Bucket
Use this for general application data (like user uploads or static assets processed by a backend).

```hcl
module "app_assets" {
  source = "../../storage/s3"

  project     = "bitmatrix"
  environment = "prod"
  bucket_name = "app-assets"
  
  # Defaults:
  # - Block all public access: TRUE
  # - Server-Side Encryption: AES256 (Amazon Managed)
  # - Versioning: FALSE
}
```

### 2. High-Security Bucket (KMS Encrypted & Versioned)
Use this for highly sensitive data like database backups, financial records, or PII.

```hcl
# 1. Create a dedicated KMS key
module "backup_kms" {
  source      = "../../security/kms"
  project     = "bitmatrix"
  environment = "prod"
  alias_name  = "s3-backup-key"
}

# 2. Create the Bucket
module "secure_backups" {
  source = "../../storage/s3"

  project     = "bitmatrix"
  environment = "prod"
  bucket_name = "db-backups"
  
  enable_versioning = true
  kms_key_arn       = module.backup_kms.key_arn
}
```

### 3. Cost-Optimized Archival Bucket (Lifecycle Rules)
Use this for log files or old backups that need to be kept for compliance but rarely accessed.

```hcl
module "audit_logs" {
  source = "../../storage/s3"

  project     = "bitmatrix"
  environment = "prod"
  bucket_name = "audit-logs"
  
  lifecycle_rules = [
    {
      id              = "archive-old-logs"
      enabled         = true
      prefix          = "historical/" # Only applies to this folder
      transition_days = 30            # Move to STANDARD_IA after 30 days
      storage_class   = "STANDARD_IA"
      expiration_days = 365           # Delete after 1 year
    }
  ]
}
```

## 🏗 Key Features
*   **Secure by Default**: `aws_s3_bucket_public_access_block` is enabled by default.
*   **Dynamic Encryption**: Automatically falls back to Amazon `AES256` if no custom `kms_key_arn` is provided.
*   **Flexible Lifecycles**: Supports passing an array of objects to dynamically generate complex lifecycle transition rules.

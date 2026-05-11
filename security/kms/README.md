# KMS Module

This module manages AWS Key Management Service (KMS) keys and aliases. It supports standard encryption use cases and advanced **Crypto-shredding** strategies.

## 🚀 Example Usage

### 1. General Purpose Encryption (Long-term Storage)
Use this for S3 buckets, RDS databases, or EBS volumes where data needs to persist for years and rotation is preferred.

```hcl
module "general_kms" {
  source = "../../security/kms"

  project     = "bitmatrix"
  environment = "prod"
  description = "KMS key for RDS database encryption"
  alias_name  = "rds-storage-key"
  
  # Standard 30-day safety window before deletion
  deletion_window_in_days = 30
  enable_key_rotation     = true
}
```

### 2. Crypto-Shredding (Fast Deletion)
Use this for sensitive PII or tenant-specific data where deleting the key is used to "shred" all data encrypted by it.

```hcl
module "tenant_pii_shredder" {
  source = "../../security/kms"

  project     = "bitmatrix"
  environment = "prod"
  description = "Tenant-A specific PII key - DELETE TO SHRED DATA"
  alias_name  = "tenant-a-pii-shredder"
  
  # Minimum 7-day window for faster data destruction
  deletion_window_in_days = 7
  
  # Rotation is often disabled for shredding keys to maintain a 1:1 key-to-data relationship
  enable_key_rotation     = false 
}
```

### 3. Secrets Manager Encryption
Use this to provide custom encryption for your highly sensitive Secrets Manager keys.

```hcl
module "secrets_kms" {
  source = "../../security/kms"

  project     = "bitmatrix"
  environment = "prod"
  description = "KMS key for Secrets Manager encryption"
  alias_name  = "secrets-encryption-key"
}

# Example integration with Secrets Manager module
module "api_secret" {
  source     = "../../security/secrets-manager"
  secret_name = "app-api-key"
  kms_key_id  = module.secrets_kms.key_arn
}
```

## 🔐 Key Policy
By default, this module uses the AWS default key policy (if `key_policy` is null), which grants the root user full access. For production, it is highly recommended to provide a custom JSON policy that restricts access to specific IAM roles.

```hcl
key_policy = jsonencode({
  Version = "2012-10-17"
  Id      = "key-consolepolicy-3"
  Statement = [
    {
      Sid    = "Enable IAM User Permissions"
      Effect = "Allow"
      Principal = {
        AWS = "arn:aws:iam::123456789012:root"
      }
      Action   = "kms:*"
      Resource = "*"
    },
    {
      Sid    = "Allow access for Key Administrators"
      Effect = "Allow"
      Principal = {
        AWS = "arn:aws:iam::123456789012:role/AdminRole"
      }
      Action   = "kms:*"
      Resource = "*"
    }
  ]
})
```

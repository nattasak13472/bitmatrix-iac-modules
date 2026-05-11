# Aurora PostgreSQL Module

This module manages an Amazon Aurora PostgreSQL cluster. It supports standard regional deployments and **Global Cluster** architectures for Disaster Recovery (DR).

## 🚀 Example Usage

### 1. Standard (Non-Global) Use Case
A standard cluster with a writer and a reader instance.

```hcl
module "db" {
  source = "../../database/aurora-postgresql"

  project         = "bitmatrix"
  environment     = "nonprod"
  name            = "app-db"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnets
  security_group_ids = [module.db_sg.id]
  
  # RECOMMENDED: Let AWS manage the password in Secrets Manager
  manage_master_user_password = true
  
  # OPTIONAL: Use a custom KMS key for storage encryption
  # kms_key_id = module.db_kms.key_arn
}
```

### 2. How to retrieve the Managed Password
If you set `manage_master_user_password = true`, Terraform will not know the password. You can retrieve it from the AWS Console or via the CLI:
1.  Go to **Secrets Manager** in the AWS Console.
2.  Search for a secret named like `rds-db-credentials/cluster-XXXX`.
3.  Your app (e.g., an ECS task) can fetch this secret using an IAM role.

### 3. Global Cluster Use Case (DR Site Setup)

> [!IMPORTANT]
> **KMS Keys in Global Clusters**: KMS keys are region-specific. If you use a custom `kms_key_id` for your global database, you **must** provide a KMS key ARN that exists in the *same region* where the cluster is being deployed. 
> *   Primary cluster -> Use Primary Region KMS key
> *   Secondary cluster -> Use Secondary Region KMS key
> Aurora will automatically handle decrypting data from the primary and re-encrypting it in the secondary using your regional keys.

To set up a Global Cluster, you need to create a `aws_rds_global_cluster` resource and then deploy this module twice (once in each region).


#### Primary Region (e.g., ap-southeast-1)
```hcl
resource "aws_rds_global_cluster" "main" {
  global_cluster_identifier = "bitmatrix-global-db"
  engine                    = "aurora-postgresql"
  engine_version            = "15.4"
}

module "primary_db" {
  source = "../../database/aurora-postgresql"

  project                   = "bitmatrix"
  environment               = "prod"
  name                      = "prod-primary"
  global_cluster_identifier = aws_rds_global_cluster.main.id
  is_primary_cluster        = true
  
  # ... network config for Region 1
}
```

#### Secondary Region (DR Site - e.g., us-east-1)
Note: No master password or database name is needed here, as they are inherited from the primary.

```hcl
module "secondary_db" {
  source = "../../database/aurora-postgresql"

  project                   = "bitmatrix"
  environment               = "prod"
  name                      = "prod-secondary"
  global_cluster_identifier = "bitmatrix-global-db" # Match the ID above
  is_primary_cluster        = false
  
  # ... network config for Region 2 (DR Site)
}
```

## 🏗 Key Features
*   **Encrypted Storage**: Storage is always encrypted. Supports both AWS-managed keys and **Customer Managed Keys (KMS)**.
*   **Managed Secrets**: Integration with AWS Secrets Manager for automated password generation and rotation.
*   **Multi-Region Ready**: Conditional logic automatically handles secondary cluster requirements (disabling backups and inheriting credentials).
*   **Graviton Ready**: Defaulted to `db.t4g.medium` for better price/performance.

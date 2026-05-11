# Secrets Manager Module

This module manages AWS Secrets Manager secrets. It is designed to keep sensitive data out of your codebase and Terraform state.

## 🚀 Recommended Strategy: "Shell & Fill"

The safest way to manage secrets (like API keys, GitLab tokens, etc.) is to create the **container** with Terraform and fill the **value** manually in the AWS Console. This ensures the secret never exists in your `tfvars`, shell history, or state files.

### Step 1: Create the Secret Shell
In your Terraform code, call the module **without** providing the `secret_string`:

```hcl
module "external_api_token" {
  source      = "../../security/secrets-manager"
  project     = "bitmatrix"
  environment = "prod"
  secret_name = "stripe-api-key"
  description = "Production API key for Stripe integration"
}
```

### Step 2: Run Terraform
Run `terraform apply`. This will create a secret in AWS named `bitmatrix/prod/stripe-api-key`, but it will have no value.

### Step 3: Fill the Value Manually
1.  Log into the **AWS Management Console**.
2.  Navigate to **Secrets Manager**.
3.  Click on your new secret: `bitmatrix/prod/stripe-api-key`.
4.  Scroll down to **Secret value** and click **Retrieve secret value**.
5.  Click **Set secret value**.
6.  Enter your sensitive key and click **Save**.

---

## 🛠 Other Use Cases

### 1. Auto-Generated Passwords
Use this for passwords that don't need to be human-readable.

```hcl
resource "random_password" "service_user" {
  length  = 32
  special = true
}

module "service_secret" {
  source        = "../../security/secrets-manager"
  project       = "bitmatrix"
  environment   = "prod"
  secret_name   = "internal-service-pwd"
  secret_string = random_password.service_user.result
}
```

### 2. JSON Structure with Placeholders
Use this if your app expects a specific JSON format.

```hcl
module "app_config" {
  source      = "../../security/secrets-manager"
  project     = "bitmatrix"
  environment = "prod"
  secret_name = "app-config"
  
  secret_string = jsonencode({
    db_host = "rds.internal"
    api_key = "REPLACE_IN_CONSOLE"
  })
}
```

## 🏗 Key Features
*   **Encrypted**: Supports custom KMS keys for encryption.
*   **Safe Deletion**: Automatically disables the recovery window (instant deletion) in non-prod environments to avoid "name already exists" errors during testing.
*   **Tagging**: Standardized naming convention for easy discovery.

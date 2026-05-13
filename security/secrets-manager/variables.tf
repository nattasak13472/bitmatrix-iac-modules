variable "project" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "resource_name" {
  description = "Name of the secret"
  type        = string
}

variable "description" {
  description = "Description of the secret"
  type        = string
  default     = "Managed by Terraform"
}

variable "kms_key_id" {
  description = "Optional: KMS key ARN to encrypt the secret"
  type        = string
  default     = null
}

variable "secret_string" {
  description = "Optional: The secret value (string). If not provided, the secret is created empty for manual entry."
  type        = string
  default     = null
  sensitive   = true
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}

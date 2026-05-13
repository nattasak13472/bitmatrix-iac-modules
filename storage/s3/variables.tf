variable "project" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "resource_name" {
  description = "The name of the bucket. If omitted, Terraform will assign a random, unique name."
  type        = string
}

variable "force_destroy" {
  description = "A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable."
  type        = bool
  default     = false
}

variable "block_public_access" {
  description = "Whether to block all public access to the bucket. Highly recommended to keep true."
  type        = bool
  default     = true
}

variable "kms_key_arn" {
  description = "Optional: The ARN of the KMS key to use for encryption. If not provided, AES256 (Amazon S3-managed keys) will be used."
  type        = string
  default     = null
}

variable "enable_versioning" {
  description = "Whether to enable versioning on the bucket"
  type        = bool
  default     = false
}

variable "lifecycle_rules" {
  description = "List of lifecycle rules to configure. Example: [{ id = 'rule-1', enabled = true, prefix = 'logs/', transition_days = 30, storage_class = 'STANDARD_IA', expiration_days = 90 }]"
  type = list(object({
    id              = string
    enabled         = bool
    prefix          = string
    transition_days = optional(number)
    storage_class   = optional(string)
    expiration_days = optional(number)
  }))
  default = []
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}

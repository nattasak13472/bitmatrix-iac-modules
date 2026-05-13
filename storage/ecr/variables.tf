variable "project" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "resource_name" {
  description = "The name of the ECR repository"
  type        = string
}

variable "image_tag_mutability" {
  description = "The tag mutability setting for the repository. Must be one of: MUTABLE or IMMUTABLE."
  type        = string
  default     = "IMMUTABLE"
}

variable "scan_on_push" {
  description = "Indicates whether images are scanned after being pushed to the repository (true) or not scanned (false)."
  type        = bool
  default     = true
}

variable "kms_key_arn" {
  description = "Optional: The ARN of the KMS key to use for encryption. If not provided, AES256 (Amazon ECR-managed keys) will be used."
  type        = string
  default     = null
}

variable "keep_last_n_images" {
  description = "The number of tagged images to retain in the repository. Older images will be deleted by the lifecycle policy to save costs."
  type        = number
  default     = 30
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}

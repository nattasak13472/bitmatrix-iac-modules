variable "project" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "domain_name" {
  description = "Domain name for the certificate"
  type        = string
  default     = null
}

variable "certificate_body" {
  description = "The certificate body (for imported certificates)"
  type        = string
  default     = null
}

variable "private_key" {
  description = "The private key (for imported certificates)"
  type        = string
  sensitive   = true
  default     = null
}

variable "certificate_chain" {
  description = "The certificate chain (for imported certificates)"
  type        = string
  default     = null
}

variable "validation_method" {
  description = "Method to use for validation (DNS or EMAIL)"
  type        = string
  default     = "DNS"
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}

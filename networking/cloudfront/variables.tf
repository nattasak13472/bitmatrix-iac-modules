variable "project" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "domain_name" {
  description = "The primary domain name for the distribution"
  type        = string
}

variable "origin_domain_name" {
  description = "The DNS name of the origin (e.g., ALB DNS name)"
  type        = string
}

variable "origin_id" {
  description = "A unique identifier for the origin"
  type        = string
}

variable "acm_certificate_arn" {
  description = "The ARN of the ACM certificate (must be in us-east-1)"
  type        = string
  default     = null
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}

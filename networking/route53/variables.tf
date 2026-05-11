variable "project" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "domain_name" {
  description = "The domain name of the hosted zone"
  type        = string
}

variable "is_private_zone" {
  description = "Whether this is a private hosted zone"
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "The VPC ID to associate with a private hosted zone"
  type        = string
  default     = null
}

variable "records" {
  description = "A list of DNS records to create"
  type = list(object({
    name    = string
    type    = string
    ttl     = number
    records = list(string)
  }))
  default = []
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}

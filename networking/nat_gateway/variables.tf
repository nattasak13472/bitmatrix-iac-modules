variable "project" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "eip_allocation_ids" {
  description = "List of EIP allocation IDs"
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "internet_gateway_id" {
  description = "The ID of the IGW (for dependency tracking)"
  type        = string
  default     = null
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}

variable "single_nat_gateway" {
  description = "Whether to use a single NAT Gateway or one per AZ"
  type        = bool
  default     = false
}

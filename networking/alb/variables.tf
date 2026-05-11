variable "project" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "alb_name" {
  description = "Name of the ALB"
  type        = string
}

variable "internal" {
  description = "If true, the LB will be internal"
  type        = bool
  default     = false
}

variable "security_groups" {
  description = "List of security group IDs to assign to the LB"
  type        = list(string)
}

variable "subnet_ids" {
  description = "List of subnet IDs to launch the LB in"
  type        = list(string)
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}

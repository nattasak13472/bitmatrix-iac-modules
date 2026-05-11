variable "project" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "name_suffix" {
  description = "A suffix to differentiate multiple capacity providers in the same cluster"
  type        = string
}

variable "cluster_name" {
  description = "The name of the ECS cluster to join"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for the cluster nodes"
  type        = string
  default     = "t3.medium"
}

variable "ami_id" {
  description = "The AMI ID for the ECS nodes (must be ECS-optimized)"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs to launch the ECS nodes in"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs for the ECS nodes"
  type        = list(string)
}

variable "key_name" {
  description = "The key name for the instances"
  type        = string
  default     = null
}

variable "min_size" {
  description = "Minimum size of the ASG"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum size of the ASG"
  type        = number
  default     = 3
}

variable "desired_capacity" {
  description = "Desired capacity of the ASG"
  type        = number
  default     = 1
}

variable "iam_instance_profile_name" {
  description = "The IAM instance profile name to use for ECS nodes. This must be created externally."
  type        = string
}

variable "additional_user_data" {
  description = "Optional: Additional shell commands to run on the ECS nodes during bootstrap"
  type        = string
  default     = ""
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}

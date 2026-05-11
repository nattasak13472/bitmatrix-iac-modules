variable "project" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "name" {
  description = "Name of the Aurora cluster"
  type        = string
}

variable "engine_version" {
  description = "The database engine version"
  type        = string
  default     = "15.4"
}

variable "instance_class" {
  description = "Instance class for the aurora instances"
  type        = string
  default     = "db.t4g.medium"
}

variable "instance_count" {
  description = "Number of instances in the cluster"
  type        = number
  default     = 2
}

variable "database_name" {
  description = "Name of the default database"
  type        = string
  default     = "main"
}

variable "master_username" {
  description = "Master username for the database"
  type        = string
  default     = "admin"
}

variable "master_password" {
  description = "Master password. Ignored if manage_master_user_password is true or if joining a global cluster."
  type        = string
  default     = null
  sensitive   = true
}

variable "manage_master_user_password" {
  description = "Whether to allow RDS to manage the master user password in Secrets Manager"
  type        = bool
  default     = true
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the DB subnet group"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
}

variable "global_cluster_identifier" {
  description = "Optional: The global cluster identifier to join"
  type        = string
  default     = null
}

variable "kms_key_id" {
  description = "Optional: The KMS key ARN to use for storage encryption"
  type        = string
  default     = null
}

variable "is_primary_cluster" {
  description = "Whether this is the primary cluster in a global setup (used for password/backup logic)"
  type        = bool
  default     = true
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}

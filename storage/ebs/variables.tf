variable "project" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "resource_name" {
  description = "Name of the EBS volume"
  type        = string
}

variable "availability_zone" {
  description = "The AZ where the EBS volume will exist"
  type        = string
}

variable "size" {
  description = "The size of the drive in GiBs"
  type        = number
}

variable "type" {
  description = "The type of EBS volume"
  type        = string
  default     = "gp3"
}

variable "encrypted" {
  description = "Whether to encrypt the volume"
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "The ARN for the KMS encryption key"
  type        = string
  default     = null
}

variable "instance_id" {
  description = "Optional: The ID of the instance to attach the volume to"
  type        = string
  default     = null
}

variable "device_name" {
  description = "Optional: The device name to expose to the instance (e.g., /dev/sdb)"
  type        = string
  default     = "/dev/sdb"
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}

variable "role_name" {
  description = "The name of the IAM role"
  type        = string
}

variable "assume_role_policy" {
  description = "The policy that grants an entity permission to assume the role"
  type        = string
}

variable "managed_policy_arns" {
  description = "A list of managed policy ARNs to attach to the role"
  type        = list(string)
  default     = []
}

variable "inline_policies" {
  description = "A map of inline policies to attach to the role"
  type = map(object({
    policy = string
  }))
  default = {}
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}

variable "project" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "name" {
  description = "Name of the ECS service"
  type        = string
}

variable "cluster_id" {
  description = "The ID of the ECS cluster to deploy the service to"
  type        = string
}

variable "container_definitions" {
  description = "JSON encoded string representing the container definitions"
  type        = string
}

variable "scheduling_strategy" {
  description = "The scheduling strategy to use for the service: REPLICA or DAEMON"
  type        = string
  default     = "REPLICA"
}

variable "desired_count" {
  description = "Number of instances of the task definition to place and keep running (ignored for DAEMON)"
  type        = number
  default     = 1
}

variable "network_mode" {
  description = "The Docker networking mode to use for the containers in the task"
  type        = string
  default     = "bridge"
}

variable "cpu" {
  description = "Number of cpu units used by the task"
  type        = number
  default     = 256
}

variable "memory" {
  description = "Amount (in MiB) of memory used by the task"
  type        = number
  default     = 512
}

variable "execution_role_arn" {
  description = "The ARN of the task execution role that the Amazon ECS container agent and the Docker daemon can assume"
  type        = string
}

variable "task_role_arn" {
  description = "The ARN of IAM role that allows your Amazon ECS container task to make calls to other AWS services"
  type        = string
  default     = null
}

# --- Load Balancing Variables (Optional) ---

variable "target_group_arn" {
  description = "Optional: The ARN of the Load Balancer target group to associate with the service"
  type        = string
  default     = null
}

variable "container_name" {
  description = "Optional: The name of the container to associate with the load balancer (required if target_group_arn is provided)"
  type        = string
  default     = null
}

variable "container_port" {
  description = "Optional: The port on the container to associate with the load balancer (required if target_group_arn is provided)"
  type        = number
  default     = null
}

# --- Storage / Volumes ---

variable "volumes" {
  description = "Optional: A list of volume definitions to make available to the task. Used for binding EBS mounts or EFS to the containers."
  type = list(object({
    name      = string
    host_path = optional(string)
  }))
  default = []
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}

variable "project" {
  description = "Project name for resource naming and tagging"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., nonprod, prod)"
  type        = string
}

variable "region" {
  description = "AWS region for resource naming"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where the Client VPN will be deployed"
  type        = string
}

variable "private_app_subnet_ids" {
  description = "List of private subnet IDs to associate with the Client VPN"
  type        = list(string)
}

variable "vpc_cidr_block" {
  description = "The CIDR block of the VPC for authorization rules"
  type        = string
}

variable "saml_provider_arn" {
  description = "The ARN of the IAM SAML identity provider for federated authentication"
  type        = string
}

variable "client_vpn_server_cert_arn" {
  description = "ACM ARN for the server certificate used by the VPN endpoint"
  type        = string
  default     = null
}

variable "self_service_saml_provider_arn" {
  description = "The ARN of the IAM SAML identity provider for the self-service portal"
  type        = string
  default     = null
}

variable "client_vpn_client_cidr" {
  description = "CIDR block to be assigned to VPN clients"
  type        = string
  default     = "172.16.0.0/22"
}

variable "common_tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

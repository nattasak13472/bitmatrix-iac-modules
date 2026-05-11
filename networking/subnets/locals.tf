locals {
  name_prefix = "${var.project}-${var.environment}-vpc-${var.region}"

  common_tags = merge(
    var.common_tags,
    {
      Project      = var.project
      Environment  = var.environment
      ManagedBy    = "Terraform"
      ModuleSource = "networking"
    }
  )
}

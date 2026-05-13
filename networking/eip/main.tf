resource "aws_eip" "nat" {

  domain = "vpc"

  tags = merge(
    var.common_tags,
    {
      Name = "${local.name_prefix}-eip-${var.resource_name}"
    }
  )
}

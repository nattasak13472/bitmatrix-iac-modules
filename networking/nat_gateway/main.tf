resource "aws_nat_gateway" "this" {
  count         = length(var.availability_zones)
  allocation_id = var.eip_allocation_ids[count.index]
  subnet_id     = var.public_subnet_ids[count.index]

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-nat-${count.index + 1}"
    }
  )

  # Explicit dependency on IGW if provided
  # Note: In separate state files, this is more for documentation/safety
  # as Terraform won't be able to wait for a resource in another state.
}

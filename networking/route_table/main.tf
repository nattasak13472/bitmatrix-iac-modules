# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.internet_gateway_id
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${local.name_prefix}-rt-public"
    }
  )
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_ids)
  subnet_id      = var.public_subnet_ids[count.index]
  route_table_id = aws_route_table.public.id
}

# Private Route Tables (one per AZ for NAT Gateway HA)
resource "aws_route_table" "private" {
  count  = length(var.availability_zones)
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = var.single_nat_gateway ? var.nat_gateway_ids[0] : var.nat_gateway_ids[count.index]
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${local.name_prefix}-rt-private-${count.index + 1}"
    }
  )
}

resource "aws_route_table_association" "private_app" {
  count          = length(var.private_app_subnet_ids)
  subnet_id      = var.private_app_subnet_ids[count.index]
  route_table_id = aws_route_table.private[count.index].id
}

resource "aws_route_table_association" "private_db" {
  count          = length(var.private_db_subnet_ids)
  subnet_id      = var.private_db_subnet_ids[count.index]
  route_table_id = aws_route_table.private[count.index].id
}

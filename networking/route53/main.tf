resource "aws_route53_zone" "this" {
  name = var.domain_name

  dynamic "vpc" {
    for_each = var.is_private_zone ? toset(var.vpc_ids) : []
    content {
      vpc_id = vpc.value
    }
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project}-${var.environment}-${var.domain_name}"
    }
  )
}

resource "aws_route53_record" "this" {
  for_each = { for record in var.records : record.name => record }

  zone_id = aws_route53_zone.this.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = each.value.ttl
  records = each.value.records
}

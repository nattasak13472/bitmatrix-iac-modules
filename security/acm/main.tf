resource "aws_acm_certificate" "this" {
  domain_name               = var.domain_name
  subject_alternative_names = var.subject_alternative_names
  validation_method         = var.domain_name != null ? var.validation_method : null

  certificate_body  = var.certificate_body
  private_key       = var.private_key
  certificate_chain = var.certificate_chain

  tags = merge(
    var.common_tags,
    {
      Name = var.domain_name != null ? "${var.project}-${var.environment}-${var.domain_name}" : "${var.project}-${var.environment}-imported-cert"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

# Client VPN Endpoint
resource "aws_ec2_client_vpn_endpoint" "this" {
  count                  = var.client_vpn_server_cert_arn != null ? 1 : 0
  description            = "${var.project}-${var.environment} Client VPN"
  server_certificate_arn = var.client_vpn_server_cert_arn
  client_cidr_block      = var.client_vpn_client_cidr
  split_tunnel           = true

  # Federated (SAML) authentication (e.g., Google SSO)
  authentication_options {
    type                           = "federated-authentication"
    saml_provider_arn              = var.saml_provider_arn
    self_service_saml_provider_arn = var.self_service_saml_provider_arn
  }

  connection_log_options {
    enabled = false
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${local.name_prefix}-vpn"
    }
  )
}

# Network Associations (Associate with Private App subnets)
resource "aws_ec2_client_vpn_network_association" "this" {
  count                  = var.client_vpn_server_cert_arn != null ? length(var.private_app_subnet_ids) : 0
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.this[0].id
  subnet_id              = var.private_app_subnet_ids[count.index]
}

# Authorization Rule (Allow access to VPC CIDR)
resource "aws_ec2_client_vpn_authorization_rule" "this" {
  count                  = var.client_vpn_server_cert_arn != null ? 1 : 0
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.this[0].id
  target_network_cidr    = var.vpc_cidr_block
  authorize_all_groups   = true
}

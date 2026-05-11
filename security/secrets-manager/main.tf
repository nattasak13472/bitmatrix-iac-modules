resource "aws_secretsmanager_secret" "this" {
  name        = "${var.project}/${var.environment}/${var.secret_name}"
  description = var.description
  kms_key_id  = var.kms_key_id

  recovery_window_in_days = var.environment == "prod" ? 30 : 0

  tags = var.common_tags
}

resource "aws_secretsmanager_secret_version" "this" {
  count         = var.secret_string != null ? 1 : 0
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = var.secret_string

  lifecycle {
    ignore_changes = [secret_string]
  }
}

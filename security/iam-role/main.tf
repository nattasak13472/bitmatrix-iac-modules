resource "aws_iam_role" "this" {
  name               = var.resource_name
  assume_role_policy = var.assume_role_policy

  dynamic "inline_policy" {
    for_each = var.inline_policies
    content {
      name   = inline_policy.key
      policy = inline_policy.value.policy
    }
  }

  tags = var.common_tags
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each = toset(var.managed_policy_arns)

  role       = aws_iam_role.this.name
  policy_arn = each.value
}

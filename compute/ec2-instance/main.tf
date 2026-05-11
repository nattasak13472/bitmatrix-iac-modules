resource "aws_instance" "this" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id

  vpc_security_group_ids = var.vpc_security_group_ids
  key_name               = var.key_name
  user_data              = var.user_data
  iam_instance_profile   = var.iam_instance_profile

  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = var.root_volume_type
    delete_on_termination = true
    encrypted             = true

    tags = merge(
      var.common_tags,
      {
        Name = "${var.project}-${var.environment}-${var.instance_name}-root"
      }
    )
  }

  tags = merge(
    var.common_tags,
    {
      Name        = "${var.project}-${var.environment}-${var.instance_name}"
      Environment = var.environment
    }
  )

  lifecycle {
    ignore_changes = [ami] # Prevent accidental replacement if AMI is updated globally
  }
}

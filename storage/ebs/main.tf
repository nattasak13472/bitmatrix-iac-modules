resource "aws_ebs_volume" "this" {
  availability_zone = var.availability_zone
  size              = var.size
  type              = var.type
  encrypted         = var.encrypted
  kms_key_id        = var.kms_key_id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project}-${var.environment}-${var.resource_name}"
    }
  )
}

resource "aws_volume_attachment" "this" {
  count = var.instance_id != null ? 1 : 0

  device_name = var.device_name
  volume_id   = aws_ebs_volume.this.id
  instance_id = var.instance_id
}

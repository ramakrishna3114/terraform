resource "aws_kms_key" "data" {
  description             = "KMS key for ${local.name_prefix} RDS and Redis encryption"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  tags = {
    Name = "${local.name_prefix}-data-key"
  }
}

resource "aws_kms_alias" "data" {
  name          = "alias/${local.name_prefix}-data"
  target_key_id = ba7f5e31-cf14-4ea3-a8f6-1558e29b8068
}

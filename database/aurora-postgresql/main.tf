# 1. Subnet Group
resource "aws_db_subnet_group" "this" {
  name       = "${var.project}-${var.environment}-${var.name}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = var.common_tags
}

# 2. Aurora Cluster
resource "aws_rds_cluster" "this" {
  cluster_identifier = "${var.project}-${var.environment}-${var.name}"
  engine             = "aurora-postgresql"
  engine_version     = var.engine_version
  database_name      = var.is_primary_cluster ? var.database_name : null
  master_username    = var.is_primary_cluster ? var.master_username : null
  master_password    = var.is_primary_cluster && !var.manage_master_user_password ? var.master_password : null

  manage_master_user_password = var.is_primary_cluster ? var.manage_master_user_password : null

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = var.security_group_ids

  # Global Cluster Link
  global_cluster_identifier = var.global_cluster_identifier

  # Basic settings
  skip_final_snapshot = var.environment != "prod" ? true : false
  storage_encrypted   = true
  kms_key_id          = var.kms_key_id

  # Backup logic (only for primary)
  backup_retention_period = var.is_primary_cluster ? 7 : 0

  tags = var.common_tags
}

# 3. Cluster Instances
resource "aws_rds_cluster_instance" "this" {
  count = var.instance_count

  identifier         = "${var.project}-${var.environment}-${var.name}-${count.index}"
  cluster_identifier = aws_rds_cluster.this.id
  instance_class     = var.instance_class
  engine             = aws_rds_cluster.this.engine
  engine_version     = aws_rds_cluster.this.engine_version

  tags = var.common_tags
}

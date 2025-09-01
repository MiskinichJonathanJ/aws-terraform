locals {
  resource_prefix = "${var.project_name}-${var.environment}"

  default_tags = merge(var.common_tags, {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
    CreatedDate = formatdate("YYYY-MM-DD", timestamp())
  })
}

resource "aws_secretsmanager_secret" "db_password" {
  name                    = "${local.resource_prefix}-db-password"
  description             = "Creadenciales para RDS  MySQL"
  recovery_window_in_days = 7

  tags = merge(local.default_tags, {
    Type = "db-credentials"
  })
}
resource "random_password" "db_password" {
  length  = 16
  special = true

  override_special = "!#$%&*()-=+[]{}<>:?"
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id = aws_secretsmanager_secret.db_password.id
  secret_string = jsonencode({
    username = var.db_username
    password = random_password.db_password.result
  })
}

resource "aws_db_instance" "MyDB" {
  allocated_storage      = 10
  db_name                = replace("${local.resource_prefix}mydb", "-", "")
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = var.instance_db_type
  username               = var.db_username
  password               = random_password.db_password.result
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.subnet_db.name
  vpc_security_group_ids = var.vpc_security_groups_ids
  multi_az               = true

  #Config securirty  and backup
  backup_retention_period = var.db_backup_retention
  backup_window           = "03:00-04:00"
  maintenance_window      = "sun:04:00-sun:05:00"
  storage_encrypted       = true
}

resource "aws_db_subnet_group" "subnet_db" {
  name       = "${local.resource_prefix}-subnet-db"
  subnet_ids = var.subnets_private_ids

  tags = local.default_tags
}

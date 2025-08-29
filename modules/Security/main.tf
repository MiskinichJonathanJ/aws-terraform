locals {
  resource_prefix = "${var.project_name}-${var.environment}"

  default_tags = merge(var.common_tags, {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
    CreatedDate = formatdate("YYYY-MM-DD", timestamp())
  })
}

######### WEB GROUP ############################
resource "aws_security_group" "web_sg" {
  name        = "${local.resource_prefix}-web-sg"
  description = "permitir el trafico http/https"
  vpc_id      = var.vpc_id_net
  tags = merge(local.default_tags, {
    Type = "Security Group"
  })
}

resource "aws_vpc_security_group_ingress_rule" "permitir_http" {
  security_group_id = aws_security_group.web_sg.id

  cidr_ipv4   = var.allowed_cidr_blocks_http
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

resource "aws_vpc_security_group_egress_rule" "permitir_http_out" {
  security_group_id = aws_security_group.web_sg.id

  cidr_ipv4   = var.allowed_cidr_blocks_http
  ip_protocol = "-1"
}

############ APP GROUP ########################
resource "aws_security_group" "app_sg" {
  name        = "${local.resource_prefix}-app-sg"
  description = "permitir  comunicacion con web_sg"
  vpc_id      = var.vpc_id_net
  tags = merge(local.default_tags, {
    Type = "Security Group"
  })
}

resource "aws_vpc_security_group_egress_rule" "permitir_all_out" {
  security_group_id = aws_security_group.app_sg.id

  cidr_ipv4   = var.allowed_cidr_blocks_http
  ip_protocol = "-1"
}

######## DATABASE  GROUP #####################
resource "aws_security_group" "db_sg" {
  name        = "${local.resource_prefix}-db-sg"
  description = "permitir  comunicacion con APP_sg"
  vpc_id      = var.vpc_id_net
  tags = merge(local.default_tags, {
    Type = "Security Group"
  })
}

resource "aws_vpc_security_group_egress_rule" "permitir_all_out_db" {
  security_group_id = aws_security_group.db_sg.id

  cidr_ipv4   = var.allowed_cidr_blocks_http
  ip_protocol = "-1"
}

########## COMMUNICATION APP -> DB ############
resource "aws_security_group_rule" "db_ingreso_from_app" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.db_sg.id
  source_security_group_id = aws_security_group.app_sg.id
}

########## COMMUNICATION WEB -> APP ############
resource "aws_security_group_rule" "app_ingreso_from_web" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.app_sg.id
  source_security_group_id = aws_security_group.web_sg.id
}



provider "aws" {
  region = "us-west-2" # Set the AWS region to Oregon
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"
  name    = "vpc-MyCloud"
  cidr    = "10.0.0.0/16"

  azs             = ["us-west-2a", "us-west-2b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.3.0/24", "10.0.4.0/24"]

  enable_dns_hostnames = true
}

#Consultar Informacion sobre AMI existentes
data "aws_ami" "ubuntu" {
  most_recent = true

  #Filtros para la busqueda  de la AMI
  filter {
    #Como es el nombre  del atributo por el que  vamos a filtrar
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  #ID empresa canonical que es la oficial ne desarrollo Ubuntu
  owners = ["099720109477"]
}

resource "aws_eip" "para_NAT" {}

resource "aws_nat_gateway" "nat_internet" {
  allocation_id = aws_eip.para_NAT
  subnet_id     = module.vpc.public_subnets[0]

}

resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "permitir el trafico http/https"
  vpc_id      = module.vpc.vpc_id
  tags = {
    Name = "Web_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "permitir_http" {
  security_group_id = aws_security_group.web_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

resource "aws_vpc_security_group_ingress_rule" "permitir_https" {
  security_group_id = aws_security_group.web_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  ip_protocol = "tcp"
  to_port     = 443
}

resource "aws_vpc_security_group_egress_rule" "permitir_http_out" {
  security_group_id = aws_security_group.web_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

resource "aws_security_group" "app_sg" {
  name        = "app_sg"
  description = "permitir  comunicacion con web_sg"
  vpc_id      = module.vpc.vpc_id
  tags = {
    Name = "APP_sg"
  }
}

resource "aws_security_group_rule" "app_ingreso_from_web" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.app_sg.id
  source_security_group_id = aws_security_group.web_sg.id
}

resource "aws_vpc_security_group_egress_rule" "permitir_all_out" {
  security_group_id = aws_security_group.app_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

resource "aws_security_group" "db_sg" {
  name        = "db_sg"
  description = "permitir  comunicacion con APP_sg"
  vpc_id      = module.vpc.vpc_id
  tags = {
    Name = "DB_sg"
  }
}

resource "aws_security_group_rule" "db_ingreso_from_app" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.db_sg.id
  source_security_group_id = aws_security_group.app_sg.id
}

resource "aws_vpc_security_group_egress_rule" "permitir_all_out_db" {
  security_group_id = aws_security_group.db_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

# Load Balancer
resource "aws_lb" "load_balancing" {
  name = "lb_application"
  load_balancer_type = "application"
  security_groups = [aws_security_group.web_sg.id]
  subnets = [for  subnet in module.vpc.public_subnets : subnet]
}

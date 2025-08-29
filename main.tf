provider "aws" {
  region = var.region # Set the AWS region to Oregon
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"
  name    = "vpc-MyCloud"
  cidr    = var.cidr_vpc

  azs             = slice(data.aws_availability_zones.available.names, 0, var.azs_count)
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.3.0/24", "10.0.4.0/24"]

  # NAT en alta disponibilidad
  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = true

  # IGW y DNS
  create_igw           = true
  enable_dns_support   = true
  enable_dns_hostnames = true
}

#Traer ultima version de la AMI  de Ubuntu
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
  from_port                = 3306
  to_port                  = 3306
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
  name               = "lbApplication"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web_sg.id]
  subnets            = [for subnet in module.vpc.public_subnets : subnet]
}

#  Target  group
resource "aws_lb_target_group" "app_tg" {
  name     = "appLBtg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
}

#Listener
resource "aws_lb_listener" "listener_lb_web" {
  load_balancer_arn = aws_lb.load_balancing.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

#Agregar Instancia  al Target  Group
resource "aws_lb_target_group_attachment" "instancias_app_web" {
  target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = aws_instance.app_web_instancia.id
  port             = 80
}

# Instancia  de  EC2
resource "aws_instance" "app_web_instancia" {
  instance_type   = var.instance_type
  ami             = data.aws_ami.ubuntu.id
  subnet_id       = module.vpc.private_subnets[0]
  security_groups = [aws_security_group.app_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y apache2
              systemctl start apache2
              systemctl enable apache2
              echo "<h1>Hola desde la app en EC2 con ALB</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "APP_WEB"
  }
}

#Instancia de RDS
resource "aws_db_instance" "MyDB" {
  allocated_storage      = 10
  db_name                = "mydb"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  username               = "foo"
  password               = "foobarbaz"
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.subnet_db.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  multi_az               = true
}

resource "aws_db_subnet_group" "subnet_db" {
  name       = "subnet_db"
  subnet_ids = module.vpc.private_subnets

  tags = {
    Name = "My DB subnet group"
  }
}
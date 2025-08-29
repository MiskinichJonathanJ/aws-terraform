locals {
  resource_prefix = "${var.project_name}-${var.environment}"

  default_tags = merge(var.common_tags, {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
    CreatedDate = formatdate("YYYY-MM-DD", timestamp())
  })
}

# Load Balancer
resource "aws_lb" "load_balancing" {
  name               = "${local.resource_prefix}-lbApplication"
  load_balancer_type = "application"
  security_groups    = [var.security_groups_lb_id]
  subnets            = [var.subnets_publics_lb_id]
}

#  Target  group
resource "aws_lb_target_group" "app_tg" {
  name     = "${local.resource_prefix}-appLBtg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id_net
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
  instance_type = var.instance_type
  ami           = data.aws_ami.ubuntu.id
  subnet_id     = var.subnet_id_instances_ec2
  security_groups = [var.security_groups_app_id]

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y apache2
              systemctl start apache2
              systemctl enable apache2
              echo "<h1>Hola desde la app en EC2 con ALB</h1>" > /var/www/html/index.html
              EOF

  tags = local.default_tags
}

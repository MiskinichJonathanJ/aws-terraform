locals {
  resource_prefix = "${var.project_name}-${var.environment}"

  default_tags = merge(var.common_tags, {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
    CreatedDate = formatdate("YYYY-MM-DD", timestamp())
  })
}

########### LOAD  BALANCER APP ####################
resource "aws_lb" "load_balancing" {
  name               = "${local.resource_prefix}-lbApplication"
  load_balancer_type = "application"
  security_groups    = [var.security_groups_lb_id]
  subnets            = var.subnets_publics_ids
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
######### AUTO SCALING #################
resource "aws_launch_template" "template_instance_EC2" {
  name_prefix   = local.resource_prefix
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y apache2
              systemctl start apache2
              systemctl enable apache2
              echo "<h1>Hola desde la app en EC2 con ALB</h1>" > /var/www/html/index.html
              EOF
}
resource "aws_autoscaling_group" "autoscaling_app" {
  max_size            = var.max_size_instances
  min_size            = var.min_size_instances
  desired_capacity    = var.desired_size_instances
  vpc_zone_identifier = var.subnet_id_privates
  launch_template {
    id      = aws_launch_template.template_instance_EC2.id
    version = "$Latest"
  }
  target_group_arns = [aws_lb_target_group.app_tg.arn]
}
###########  TARGET GROUP ##################
resource "aws_lb_target_group" "app_tg" {
  name     = "${local.resource_prefix}-appLBtg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id_net
}
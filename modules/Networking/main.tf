locals {
  resource_prefix = "${var.project_name}-${var.environment}"

  default_tags = merge(var.common_tags, {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
    CreatedDate = formatdate("YYYY-MM-DD", timestamp())
  })
}

data "aws_availability_zones" "available" {
  state = "available"
}

#NET
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"
  name    = "${local.resource_prefix}-vpc"
  cidr    = var.cidr_vpc

  azs             = slice(data.aws_availability_zones.available.names, 0, var.azs_count)
  private_subnets = var.private_subnets_cidr
  public_subnets  = var.public_subnets_cidr

  # NAT en alta disponibilidad
  enable_nat_gateway     = var.enable_nat_gateway
  single_nat_gateway     = var.single_nat_gateway
  one_nat_gateway_per_az = true

  # IGW y DNS
  create_igw           = true
  enable_dns_support   = true
  enable_dns_hostnames = true
}


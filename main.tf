provider "aws" {
  region = "us-west-2" # Set the AWS region to Oregon
}

module "pvc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"
  name    = "vpc-MyCloud"
  cidr    = "10.0.0.0/16"

  azs             = ["us-west-2a", "us-west-2b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.3.0/24", "10.0.4.0/24"]

  enable_dns_hostnames = true
}

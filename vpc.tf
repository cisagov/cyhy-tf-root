# Create a VPC with subnets.

module "vpc" {
  providers = {
    aws = aws.provisionaccount
  }

  source  = "cloudposse/vpc/aws"
  version = "2.1.1"

  ipv4_primary_cidr_block = var.vpc_cidr_block
  name                    = "cyhy"
  namespace               = terraform.workspace
  tags                    = var.tags
}

module "subnets" {
  providers = {
    aws = aws.provisionaccount
  }

  source  = "cloudposse/dynamic-subnets/aws"
  version = "2.4.2"

  availability_zones   = var.aws_availability_zones
  igw_id               = [module.vpc.igw_id]
  ipv4_cidr_block      = [module.vpc.vpc_cidr_block]
  nat_gateway_enabled  = true
  nat_instance_enabled = false
  tags                 = var.tags
  vpc_id               = module.vpc.vpc_id
}

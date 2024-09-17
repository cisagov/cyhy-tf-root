module "aws_key_pair" {
  providers = {
    aws = aws.provisionaccount
  }

  source  = "cloudposse/key-pair/aws"
  version = "0.18.3"

  generate_ssh_key    = true
  name                = "ec2"
  namespace           = terraform.workspace
  ssh_public_key_path = var.ssh_public_key_path
}

module "ec2" {
  providers = {
    aws = aws.provisionaccount
  }

  source  = "cloudposse/ec2-instance/aws"
  version = "1.6.0"

  associate_public_ip_address = true
  instance_type               = "t3.micro"
  name                        = "ec2"
  namespace                   = terraform.workspace
  security_group_rules = [
    # Allow ingress from trusted CIDR blocks
    {
      type        = "ingress"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = var.ec2_trusted_ingress_cidr_blocks
    },
    # Allow egress anywhere
    {
      type        = "egress"
      from_port   = 0
      to_port     = 65535
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    },
  ]
  ssh_key_pair = module.aws_key_pair.key_name
  subnet       = module.subnets.public_subnet_ids[0]
  tags         = var.tags
  vpc_id       = module.vpc.vpc_id
}

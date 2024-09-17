module "documentdb-cluster" {
  providers = {
    aws = aws.provisionaccount
  }

  source  = "cloudposse/documentdb-cluster/aws"
  version = "0.27.0"

  db_port         = var.db_port
  instance_class  = var.db_instance_class
  master_password = var.db_password
  master_username = var.db_username
  name            = var.db_name
  namespace       = terraform.workspace # TODO: Decide if this should be a parameter
  subnet_ids      = module.subnets.private_subnet_ids
  tags            = var.tags
  vpc_id          = module.vpc.vpc_id
}

# Allow ingress from the EC2 instance to the DocumentDB cluster
resource "aws_security_group_rule" "ingress_from_ec2_to_documentdb" {
  provider = aws.provisionaccount

  from_port                = var.db_port
  protocol                 = "tcp"
  security_group_id        = module.documentdb-cluster.security_group_id
  source_security_group_id = module.ec2.security_group_id
  to_port                  = var.db_port
  type                     = "ingress"
}

# Allow egress from the EC2 instance to the DocumentDB cluster
resource "aws_security_group_rule" "egress_from_ec2_to_documentdb" {
  provider = aws.provisionaccount

  from_port                = var.db_port
  protocol                 = "tcp"
  security_group_id        = module.ec2.security_group_id
  source_security_group_id = module.documentdb-cluster.security_group_id
  to_port                  = var.db_port
  type                     = "egress"
}

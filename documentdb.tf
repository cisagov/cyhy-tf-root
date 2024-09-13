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

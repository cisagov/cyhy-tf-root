# Note that we do not have an output for the entire documentdb-cluster module.
# This is because the module has at least one sensitive output (the master
# password) that we do not want to expose.  Instead, we only output the key
# pieces of information from the module that are not sensitive.

output "documentdb_arn" {
  description = "The ARN of the DocumentDB cluster."
  value       = module.documentdb-cluster.arn
}
output "documentdb_endpoint" {
  description = "The endpoint of the DocumentDB cluster."
  value       = module.documentdb-cluster.endpoint
}
output "documentdb_sg_arn" {
  description = "The ARN of the DocumentDB cluster security group."
  value       = module.documentdb-cluster.security_group_arn
}

output "ec2" {
  description = "The EC2 instance that is allowed to access the DocumentDB cluster."
  value       = module.ec2
}

output "subnets" {
  description = "The subnets within the CyHy VPC."
  value       = module.subnets
}
output "vpc" {
  description = "The CyHy VPC."
  value       = module.vpc
}

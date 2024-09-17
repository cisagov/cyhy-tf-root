# ------------------------------------------------------------------------------
# REQUIRED PARAMETERS
#
# You must provide a value for each of these parameters.
# ------------------------------------------------------------------------------

variable "ssh_public_key_path" {
  description = "The local path to store the SSH public key used to access the EC2 instance."
  type        = string
}

# ------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
#
# These parameters have reasonable defaults.
# ------------------------------------------------------------------------------

variable "aws_availability_zones" {
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
  description = "The list of AWS availability zones to deploy into (e.g. [\"us-east-1a\", \"us-east-1b\", \"us-east-1c\"]."
  type        = list(string)
}

variable "aws_region" {
  default     = "us-east-1"
  description = "The AWS region to deploy into (e.g. \"us-east-1\")."
  type        = string
}

variable "db_instance_class" {
  default     = "db.r5.large"
  description = "The instance class to use for the DocumentDB cluster."
  type        = string
}

variable "db_name" {
  default     = "cyhy"
  description = "The name of the database to create."
  type        = string
}

variable "db_password" {
  description = "The master password for the database user."
  type        = string
}

variable "db_port" {
  default     = 27017
  description = "The port to use for the DocumentDB cluster."
  type        = number
}

variable "db_username" {
  description = "The master username for the database user."
  type        = string
}

variable "ec2_trusted_ingress_cidr_blocks" {
  default     = []
  description = "The CIDR blocks to allow access to the EC2 instance."
  type        = list(string)
}

variable "tags" {
  default     = {}
  description = "Tags to apply to all AWS resources created."
  type        = map(string)
}

variable "vpc_cidr_block" {
  default     = "10.0.0.0/16"
  description = "The CIDR block to use for the VPC (e.g. \"10.0.0.0/16\")."
  type        = string
}

# ------------------------------------------------------------------------------
# REQUIRED PARAMETERS
#
# You must provide a value for each of these parameters.
# ------------------------------------------------------------------------------

variable "subnet_id" {
  description = "The ID of the AWS subnet to deploy into (e.g. subnet-0123456789abcdef0)."
  type        = string
}

# ------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
#
# These parameters have reasonable defaults.
# ------------------------------------------------------------------------------
variable "aws_availability_zone" {
  default     = "a"
  description = "The AWS availability zone to deploy into (e.g. a, b, c, etc.)."
  type        = string
}

variable "aws_region" {
  default     = "us-east-1"
  description = "The AWS region to deploy into (e.g. us-east-1)."
  type        = string
}

variable "tags" {
  default     = {}
  description = "Tags to apply to all AWS resources created"
  type        = map(string)
}

# ------------------------------------------------------------------------------
# REQUIRED PARAMETERS
#
# You must provide a value for each of these parameters.
# ------------------------------------------------------------------------------

variable "kevsync_lambda_s3_bucket" {
  description = "The name of the S3 bucket where the cyhy-kevsync Lambda deployment package is stored."
  type        = string
}

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

variable "kevsync_lambda_config_ssm_key" {
  default     = "/cyhy-kevsync/config"
  description = "The SSM key that contains the configuration to use for the Lambda function that syncs KEV data to the database in the Cyber Hygiene account."
  type        = string
}

variable "kevsync_lambda_description" {
  default     = "Syncs KEV data to the database in the Cyber Hygiene account."
  description = "The description to associate with the Lambda function that syncs KEV data to the database in the Cyber Hygiene account."
  type        = string
}

variable "kevsync_lambda_env_variables" {
  default     = {}
  description = "The environment variables to set for the Lambda function that syncs KEV data to the database in the Cyber Hygiene account."
  type        = map(string)
}

variable "kevsync_lambda_handler" {
  default     = "lambda_handler.handler"
  description = "The handler to use for the Lambda function that syncs KEV data to the database in the Cyber Hygiene account."
  type        = string
}

variable "kevsync_lambda_name" {
  default     = "cyhy-kevsync"
  description = "The name to assign the Lambda function that syncs KEV data to the database in the Cyber Hygiene account."
  type        = string
}

variable "kevsync_lambda_runtime" {
  default     = "python3.12"
  description = "The runtime to use for the Lambda function that syncs KEV data to the database in the Cyber Hygiene account."
  type        = string
}

variable "kevsync_lambda_s3_key" {
  default     = "cyhy-kevsync-lambda.zip"
  description = "The key of the cyhy-kevsync Lambda deployment package in the S3 bucket."
  type        = string
}

variable "kevsync_lambda_schedule" {
  default     = "cron(0 6 * * ? *)"
  description = "The EventBridge expression that represents when to run the Lambda function that syncs KEV data to the database in the Cyber Hygiene account.  The default value of 'cron(0 6 * * ? *)' indicates that the Lambda will run every day at 6:00 AM UTC.  For details on EventBridge expression syntax, refer to https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-scheduled-rule-pattern.html"
  type        = string
}

variable "kevsync_lambda_timeout" {
  default     = 300
  description = "The timeout (in seconds) to use for the Lambda function that syncs KEV data to the database in the Cyber Hygiene account."
  type        = number
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

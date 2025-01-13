# Create a Lambda function that runs the cyhy-cvesync-lambda code on a schedule.
#
# Prerequisites:
# - A cyhy-cvesync Lambda deployment package stored in an S3 bucket (see the
#   cvesync_lambda_s3_bucket and cvesync_lambda_s3_key variables)
# - A valid CyHy configuration stored in the Systems Manager (SSM) Parameter
#   Store of the Cyber Hygiene account (see the cvesync_lambda_config_ssm_key
#   variable)

# Fetch the Lambda deployment package from the S3 bucket where it is stored
# so that we can check its version ID and update the Lambda function when a new
# version is uploaded.
data "aws_s3_object" "cvesync_lambda" {
  provider = aws.provisionaccount

  bucket = var.cvesync_lambda_s3_bucket
  key    = var.cvesync_lambda_s3_key
}

module "cvesync_lambda" {
  providers = {
    aws = aws.provisionaccount
  }

  source  = "terraform-aws-modules/lambda/aws"
  version = "7.20.0"

  allowed_triggers = {
    cvesync = {
      principal  = "events.amazonaws.com"
      source_arn = module.cvesync_eventbridge.eventbridge_rule_arns["${var.cvesync_lambda_name}"]
    }
  }
  attach_network_policy             = true
  attach_policy_statements          = true
  cloudwatch_logs_retention_in_days = var.cvesync_lambda_cloudwatch_logs_retention_in_days

  # This is necessary to avoid the following error:
  # "InvalidParameterValueException: We currently do not support adding policies
  # for $LATEST." For more, see
  # https://github.com/terraform-aws-modules/terraform-aws-lambda/blob/v7.9.0/README.md#faq
  create_current_version_allowed_triggers = false

  create_package        = false
  description           = var.cvesync_lambda_description
  environment_variables = merge({ "CYHY_CONFIG_SSM_PATH" = var.cvesync_lambda_config_ssm_key }, var.cvesync_lambda_env_variables)
  function_name         = var.cvesync_lambda_name
  handler               = var.cvesync_lambda_handler
  memory_size           = var.cvesync_lambda_memory
  policy_statements = {
    ssm_read = {
      effect    = "Allow",
      actions   = ["ssm:GetParameter"],
      resources = ["arn:aws:ssm:${var.aws_region}:${local.cyhy_account_id}:parameter${var.cvesync_lambda_config_ssm_key}"]
    },
  }
  runtime = var.cvesync_lambda_runtime
  s3_existing_package = {
    bucket     = var.cvesync_lambda_s3_bucket
    key        = var.cvesync_lambda_s3_key
    version_id = data.aws_s3_object.cvesync_lambda.version_id
  }
  tags                   = var.tags
  timeout                = var.cvesync_lambda_timeout
  vpc_security_group_ids = [module.ec2.security_group_id]
  vpc_subnet_ids         = module.subnets.private_subnet_ids
}

# Invoke the Lamdba function to initially load CVE data into the database
resource "aws_lambda_invocation" "cvesync" {
  provider = aws.provisionaccount

  function_name = module.cvesync_lambda.lambda_function_name
  input         = "{}"
}

# Schedule the Lambda function
module "cvesync_eventbridge" {
  providers = {
    aws = aws.provisionaccount
  }

  source  = "terraform-aws-modules/eventbridge/aws"
  version = "3.13.0"

  # We are using the default bus, so no need to create it here.
  create_bus = false
  # The role allowing the Lambda to be triggered by this EventBridge rule is
  # created by the Lambda module, so no need to create it here.
  create_role = false

  rules = {
    "${var.cvesync_lambda_name}" = {
      description         = format("Executes %s Lambda on a schedule", var.cvesync_lambda_name)
      schedule_expression = var.cvesync_lambda_schedule
    }
  }

  tags = var.tags

  targets = {
    "${var.cvesync_lambda_name}" = [
      {
        arn  = module.cvesync_lambda.lambda_function_arn
        name = var.cvesync_lambda_name
      }
    ]
  }
}

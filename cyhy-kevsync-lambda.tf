# Create a Lambda function that runs the cyhy-kevsync-lambda code on a schedule.
#
# Prerequisites:
# - A cyhy-kevsync Lambda deployment package stored in an S3 bucket (see the
#   kevsync_lambda_s3_bucket and kevsync_lambda_s3_key variables)
# - A valid CyHy configuration stored in the Systems Manager (SSM) Parameter
#   Store of the Cyber Hygiene account (see the kevsync_lambda_config_ssm_key
#   variable)

module "kevsync_lambda" {
  providers = {
    aws = aws.provisionaccount
  }

  source  = "terraform-aws-modules/lambda/aws"
  version = "7.9.0"

  allowed_triggers = {
    kevsync = {
      principal  = "events.amazonaws.com"
      source_arn = module.kevsync_eventbridge.eventbridge_rule_arns["${var.kevsync_lambda_name}"]
    }
  }
  attach_network_policy    = true
  attach_policy_statements = true

  # This is necessary to avoid the following error:
  # "InvalidParameterValueException: We currently do not support adding policies
  # for $LATEST." For more, see
  # https://github.com/terraform-aws-modules/terraform-aws-lambda/blob/v7.9.0/README.md#faq
  create_current_version_allowed_triggers = false

  create_package        = false
  description           = var.kevsync_lambda_description
  environment_variables = merge({ "CYHY_CONFIG_SSM_PATH" = var.kevsync_lambda_config_ssm_key }, var.kevsync_lambda_env_variables)
  function_name         = var.kevsync_lambda_name
  handler               = var.kevsync_lambda_handler
  policy_statements = {
    ssm_read = {
      effect    = "Allow",
      actions   = ["ssm:GetParameter"],
      resources = ["arn:aws:ssm:${var.aws_region}:${local.cyhy_account_id}:parameter${var.kevsync_lambda_config_ssm_key}"]
    },
  }
  runtime = var.kevsync_lambda_runtime
  s3_existing_package = {
    bucket = var.kevsync_lambda_s3_bucket
    key    = var.kevsync_lambda_s3_key
  }
  tags    = var.tags
  timeout = var.kevsync_lambda_timeout
  # TODO: Decide if we need the EC2 instance or not.  If not, we need to create a security group for the Lambda function.
  vpc_security_group_ids = [module.ec2.security_group_id]
  vpc_subnet_ids         = module.subnets.private_subnet_ids
}

# Schedule the Lambda function
module "kevsync_eventbridge" {
  providers = {
    aws = aws.provisionaccount
  }

  source  = "terraform-aws-modules/eventbridge/aws"
  version = "3.11.0"

  create_bus  = false # We are using the default bus, so no need to create it
  create_role = false # The role is created by the Lambda module, so no need to create it here

  rules = {
    "${var.kevsync_lambda_name}" = {
      description         = format("Executes %s Lambda on a schedule", var.kevsync_lambda_name)
      schedule_expression = var.kevsync_lambda_schedule
    }
  }

  tags = var.tags

  targets = {
    "${var.kevsync_lambda_name}" = [
      {
        arn = module.kevsync_lambda.lambda_function_arn
        input = jsonencode({
          detail-type = "Scheduled Event"
          source      = "aws.events"
          task        = "sync"
        })
        name = var.kevsync_lambda_name
      }
    ]
  }
}

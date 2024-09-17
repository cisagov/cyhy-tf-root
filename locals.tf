# ------------------------------------------------------------------------------
# Retrieve the caller identity for the provider that is used to create resources
# inside the CyHy account.  This is used to determine the CyHy account ID.
# ------------------------------------------------------------------------------
data "aws_caller_identity" "cyhy" {
  provider = aws.provisionaccount
}

# ------------------------------------------------------------------------------
# Evaluate expressions for use throughout this configuration.
# ------------------------------------------------------------------------------
locals {
  # Get the CyHy account ID.
  cyhy_account_id = data.aws_caller_identity.cyhy.id
}

# cyhy-tf-root #

[![GitHub Build Status](https://github.com/cisagov/cyhy-tf-root/workflows/build/badge.svg)](https://github.com/cisagov/cyhy-tf-root/actions)

This is a [Terraform root module](https://www.terraform.io/docs/modules/index.html)
that can be used to create a Cyber Hygiene (CyHy) environment in AWS.

## Pre-requisites ##

- [Terraform](https://www.terraform.io/) installed on your system.
- An accessible AWS S3 bucket to store Terraform state
  (specified in [`backend.tf`](backend.tf)).
- An accessible AWS DynamoDB database to store the Terraform state lock
  (specified in [`backend.tf`](backend.tf)).
- To configure a CyHy account within a COOL environment, we strongly recommend
  using
  [`cisagov/cool-accounts-cyhy`](https://github.com/cisagov/cool-accounts-cyhy).
- A cyhy-kevsync Lambda deployment package stored in an S3 bucket (see the
  kevsync_lambda_s3_bucket and kevsync_lambda_s3_key variables).
- A valid CyHy configuration stored in the Systems Manager (SSM) Parameter
  Store of the Cyber Hygiene account (see the kevsync_lambda_config_ssm_key
  variable).
- A Terraform [variables](variables.tf) file customized for your use case, for
  example:

  ```hcl
  kevsync_lambda_s3_bucket = "my-lambda-deployment-artifacts"
  ssh_public_key_path      = "/home/.ssh"

  tags = {
    Team        = "DevSecOps"
    Application = "Cyber Hygiene"
  }
  ```

## Examples ##

- [Basic usage](https://github.com/cisagov/cyhy-tf-root/tree/develop/examples/basic_usage)

<!-- BEGIN_TF_DOCS -->
## Requirements ##

| Name | Version |
|------|---------|
| terraform | ~> 1.0 |
| aws | ~> 5.0 |

## Providers ##

| Name | Version |
|------|---------|
| aws.provisionaccount | ~> 5.0 |

## Modules ##

| Name | Source | Version |
|------|--------|---------|
| aws\_key\_pair | cloudposse/key-pair/aws | 0.18.3 |
| documentdb-cluster | cloudposse/documentdb-cluster/aws | 0.27.0 |
| ec2 | cloudposse/ec2-instance/aws | 1.6.0 |
| kevsync\_lambda | terraform-aws-modules/lambda/aws | 7.9.0 |
| subnets | cloudposse/dynamic-subnets/aws | 2.4.2 |
| vpc | cloudposse/vpc/aws | 2.1.1 |

## Resources ##

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.kevsync_lambda_schedule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.kevsync_lambda_schedule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_security_group_rule.egress_from_ec2_to_documentdb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress_from_ec2_to_documentdb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_caller_identity.cyhy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs ##

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_availability\_zones | The list of AWS availability zones to deploy into (e.g. ["us-east-1a", "us-east-1b", "us-east-1c"]. | `list(string)` | ```[ "us-east-1a", "us-east-1b", "us-east-1c" ]``` | no |
| aws\_region | The AWS region to deploy into (e.g. "us-east-1"). | `string` | `"us-east-1"` | no |
| db\_instance\_class | The instance class to use for the DocumentDB cluster. | `string` | `"db.r5.large"` | no |
| db\_name | The name of the database to create. | `string` | `"cyhy"` | no |
| db\_password | The master password for the database user. | `string` | n/a | yes |
| db\_port | The port to use for the DocumentDB cluster. | `number` | `27017` | no |
| db\_username | The master username for the database user. | `string` | n/a | yes |
| ec2\_trusted\_ingress\_cidr\_blocks | The CIDR blocks to allow access to the EC2 instance. | `list(string)` | `[]` | no |
| kevsync\_lambda\_config\_ssm\_key | The SSM key that contains the configuration to use for the Lambda function that syncs KEV data to the database in the Cyber Hygiene account. | `string` | `"/cyhy-kevsync/config"` | no |
| kevsync\_lambda\_description | The description to associate with the Lambda function that syncs KEV data to the database in the Cyber Hygiene account. | `string` | `"Syncs KEV data to the database in the Cyber Hygiene account."` | no |
| kevsync\_lambda\_env\_variables | The environment variables to set for the Lambda function that syncs KEV data to the database in the Cyber Hygiene account. | `map(string)` | `{}` | no |
| kevsync\_lambda\_handler | The handler to use for the Lambda function that syncs KEV data to the database in the Cyber Hygiene account. | `string` | `"lambda_handler.handler"` | no |
| kevsync\_lambda\_name | The name to assign the Lambda function that syncs KEV data to the database in the Cyber Hygiene account. | `string` | `"cyhy-kevsync"` | no |
| kevsync\_lambda\_runtime | The runtime to use for the Lambda function that syncs KEV data to the database in the Cyber Hygiene account. | `string` | `"python3.12"` | no |
| kevsync\_lambda\_s3\_bucket | The name of the S3 bucket where the cyhy-kevsync Lambda deployment package is stored. | `string` | n/a | yes |
| kevsync\_lambda\_s3\_key | The key of the cyhy-kevsync Lambda deployment package in the S3 bucket. | `string` | `"cyhy-kevsync-lambda.zip"` | no |
| kevsync\_lambda\_schedule\_interval | The interval (in minutes) to use for the schedule of the Lambda function that syncs KEV data to the database in the Cyber Hygiene account. | `number` | `1440` | no |
| kevsync\_lambda\_timeout | The timeout (in seconds) to use for the Lambda function that syncs KEV data to the database in the Cyber Hygiene account. | `number` | `300` | no |
| ssh\_public\_key\_path | The local path to store the SSH public key used to access the EC2 instance. | `string` | n/a | yes |
| tags | Tags to apply to all AWS resources created. | `map(string)` | `{}` | no |
| vpc\_cidr\_block | The CIDR block to use for the VPC (e.g. "10.0.0.0/16"). | `string` | `"10.0.0.0/16"` | no |

## Outputs ##

No outputs.
<!-- END_TF_DOCS -->

## Notes ##

Running `pre-commit` requires running `terraform init` in every directory that
contains Terraform code. In this repository, these are the main directory and
every directory under `examples/`.

## Contributing ##

We welcome contributions!  Please see [`CONTRIBUTING.md`](CONTRIBUTING.md) for
details.

## License ##

This project is in the worldwide [public domain](LICENSE).

This project is in the public domain within the United States, and
copyright and related rights in the work worldwide are waived through
the [CC0 1.0 Universal public domain
dedication](https://creativecommons.org/publicdomain/zero/1.0/).

All contributions to this project will be released under the CC0
dedication. By submitting a pull request, you are agreeing to comply
with this waiver of copyright interest.

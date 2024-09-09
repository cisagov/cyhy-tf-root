# This is the "default" provider that is used assume the roles in the other
# providers.  It uses the credentials of the caller.  It is also used to
# assume the roles required to access remote state in the Terraform backend.
provider "aws" {
  default_tags {
    tags = var.tags
  }

  region = var.aws_region
}

# This is the provider that is used to create resources inside the CyHy account.
provider "aws" {
  alias = "provisionaccount"
  default_tags {
    tags = var.tags
  }

  profile = "cool-cyhy-provisionaccount"
  region  = var.aws_region
}

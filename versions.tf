terraform {
  # If you use any other providers you should also pin them to the
  # major version currently being used.  This practice will help us
  # avoid unwelcome surprises.
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Version 1.1 of Terraform is the first version to support the
  # nullable key in variable definitions.
  required_version = ">= 1.1"
}

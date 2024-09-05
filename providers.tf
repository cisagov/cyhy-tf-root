provider "aws" {
  default_tags {
    tags = var.tags
  }
  region = var.aws_region
}

terraform {
  backend "s3" {
    bucket         = "cisa-cool-dev-a-terraform-state"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
    key            = "cyhy-tf-root/terraform.tfstate"
    profile        = "cool-terraform-backend"
    region         = "us-east-1"
  }
}

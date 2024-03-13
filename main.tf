terraform {
  backend "s3" {
    bucket = var.iac_state_bucket
    key = "terraform.tfstate"
    region = var.aws_region
  }
}

provider "aws" {
    region = var.aws_region
}
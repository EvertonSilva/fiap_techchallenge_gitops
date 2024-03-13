terraform {
  backend "s3" {
    bucket = var.tfstate_bucket_name
    key = "terraform.tfstate"
    region = var.aws_region
  }
}

provider "aws" {
    region = var.aws_region
}
# Provision bucket S3 para armazenar tfstate
provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "terraform_state_bucket" {
    bucket  = var.tfstate_bucket_name
}
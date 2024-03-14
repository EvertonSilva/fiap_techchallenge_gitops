terraform {
  backend "s3" {
    bucket = "tfstate_postech_fiap"
    key = "terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
    region = "us-east-1"
}
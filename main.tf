# Terraform Main
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.18.0"
    }
  }

  backend "s3" {
    bucket          = "postechfiapiac-tfstate"
    key             = "state/terraform.tfstate"
    region          = "us-east-1"
    encrypt         = true
    dynamodb_table  = "postechfiapiac-tf-lockid"
  }
}

provider "aws" {
  region = "us-east-1"
}

module "network" {
  source = "./modules/network"
}
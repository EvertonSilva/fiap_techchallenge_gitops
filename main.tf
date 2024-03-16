# Terraform Main

provider "aws" {
    region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket         = "postechfiap-tfstate"
    key            = "terraform.tfstate"
    region         = "us-east-1"
  }
}

module "eks_cluster" {
  source = "./eks_cluster"
}

module "rds_database" {
  source = "./rds_database"

  eks_cluster_security_group_id = module.eks_cluster.cluster_security_group_id
  postech_fiap_vpc_id = odule.eks_cluster.postech_fiap_vpc_id
}
# Terraform Main

provider "aws" {
    region = "us-east-1"
    assume_role {
      role_arn = "arn:aws:iam::637423403559:role/OrganizationAccountAccessRolePosTechDev"
    }
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

  common_tags = var.common_tags
}

module "rds_database" {
  source = "./rds_database"

  eks_cluster_security_group_id = module.eks_cluster.cluster_security_group_id
  postech_fiap_vpc_id = module.eks_cluster.postech_fiap_vpc_id
  rds_master_passwd = var.RDS_PASSWD
  common_tags = var.common_tags
}

module "ecr_repository" {
  source = "./ecr"
}
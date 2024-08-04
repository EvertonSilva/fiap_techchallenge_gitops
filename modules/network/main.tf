locals {
  vpc_cidr        = "10.0.0.0/16"
  pubsubnet_cidr  = "10.0.1.0/24"
  pvtsubnet_cidr  = "10.0.100.0/24"
}

module "vpc" {
  source = "./vpc"
  vpc_cidr_block = local.vpc_cidr
}

module "subnet" {
  source = "./subnet"
  vpc_id = module.vpc.vpc_id
  public_cidr_block = local.pubsubnet_cidr
  private_cidr_block = local.pvtsubnet_cidr
}

module "internet_gateway" {
  source = "./internet_gateway"
  vpc_id = module.vpc.vpc_id
}

module "nat_gateway" {
  source = "./nat_gateway"
  public_subnet_id = module.subnet.public_subnets[0]
}

module "route_table" {
  source = "./route_table"
  vpc_id = module.vpc.vpc_id
  igw_id = module.internet_gateway.igw_id
  nat_gateway_id = module.nat_gateway.nat_gateway_id
  public_subnets = module.subnet.public_subnets
  private_subnets = module.subnet.private_subnets
}
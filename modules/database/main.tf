module "network" {
  source = "../network"
}

module "rds" {
    source = "./rds"
    vpc_id = module.network.vpc_id
    private_subnets = module.network.private_subnets
}
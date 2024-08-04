module "network" {
  source = "../network"
}

module "rds" {
    source = "./rds"
    vpc_id = module.network.vpc_id
    private_subnet_id = module.network.private_subnet_id
}
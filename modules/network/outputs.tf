output "vpc_id" {
  description = "Identificador da VPC"
  value = module.vpc.vpc_id
}

output "public_subnets" {
  description = "Identificador da Subnet Pública"
  value = module.subnet.public_subnets
}

output "private_subnets" {
  description = "Identificador da Subnet Privada"
  value = module.subnet.private_subnets
}
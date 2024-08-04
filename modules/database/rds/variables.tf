variable "vpc_id" {
  description = "Identificador da VPC onde o banco de dados será criado"
  type = string
}

variable "private_subnet_id" {
  description = "Identificador da subnet privada onde o banco será criado"
  type = string
}

# variable "eks_securitygroup_id" {
#   description = "Identificador do security group do cluster EKS"
#   type = string
# }

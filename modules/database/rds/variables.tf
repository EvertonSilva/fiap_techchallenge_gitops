variable "vpc_id" {
  description = "Identificador da VPC onde o banco de dados será criado"
  type = string
}

variable "private_subnets" {
  description = "Ids da subnets privadas onde o banco será criado"
  type = list(string)
}


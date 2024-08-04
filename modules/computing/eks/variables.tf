variable "vpc_id" {
  description = "Identificador da VPC onde o cluster será provisionado"
  type = string
}

variable "private_subnets" {
  description = "Ids das subnets privadas para o cluster"
  type = list(string)
}

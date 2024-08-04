variable "vpc_id" {
  description = "Identificador da VPC onde a route table será criada"
  type        = string
}

variable "igw_id" {
  description = "Identificador do Internet Gateway para associar com a route table"
  type        = string
}

variable "nat_gateway_id" {
  description = "Identificador do NAT Gateway ID para associar com a route table"
  type        = string
}

variable "public_subnets" {
  description = "Ids das subnets públicas para associar com a route table"
  type        = list(string)
}

variable "private_subnets" {
  description = "Ids das subnets privadas para associar com a table"
  type        = list(string)
}
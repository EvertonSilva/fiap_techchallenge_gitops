variable "vpc_id" {
  description   = "id da vpc onde será definida a subnet"
  type          = string
}

variable "public_cidr_block" {
  description   = "CIDR para definição da faixa de IPs da subnet pública"
  type          = string
  default       = "10.0.1.0/24" 
}

variable "private_cidr_block" {
  description   = "CIDR para definição da faixa de IPs da subnet privada"
  type          = string
  default       = "10.0.101.0/24" 
}
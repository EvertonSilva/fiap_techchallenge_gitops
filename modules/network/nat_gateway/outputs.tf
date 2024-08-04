output "nat_gateway_id" {
    description = "Identificador do NAT Gateway"
    value = aws_nat_gateway.postech_nat_gateway.id
}
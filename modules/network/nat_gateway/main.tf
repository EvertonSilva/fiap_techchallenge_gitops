resource "aws_eip" "nat_gateway_ip" {
  vpc = true

  tags = {
    Name = "PosTechFiapNATGatewayEIP"
  }
}

resource "aws_nat_gateway" "postech_nat_gateway" {
  allocation_id = aws_eip.nat_gateway_ip.id
  subnet_id     = var.public_subnet_id
  
  tags = {
    Name = "PosTechFiapNATGateway"
  }
}
resource "aws_route_table" "postechfiap_pub_routetable" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_id
  }

  tags = {
    Name = "PosTechFiapRouteTablePublica"
  }
}

resource "aws_route_table_association" "postechfiap_pub_routetable_assoc_1a" {
  subnet_id      = var.public_subnets[0]
  route_table_id = aws_route_table.postechfiap_pub_routetable.id
}

resource "aws_route_table_association" "postechfiap_pub_routetable_assoc_1c" {
  subnet_id      = var.public_subnets[1]
  route_table_id = aws_route_table.postechfiap_pub_routetable.id
}

resource "aws_route_table" "postechfiap_pvt_routetable" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = var.nat_gateway_id
  }

  tags = {
    Name = "PosTechFiapRouteTablePrivada"
  }
}

resource "aws_route_table_association" "postechfiap_pvt_routetable_assoc_1a" {
  subnet_id      = var.private_subnets[0]
  route_table_id = aws_route_table.postechfiap_pvt_routetable.id
}

resource "aws_route_table_association" "postechfiap_pvt_routetable_assoc_1c" {
  subnet_id      = var.private_subnets[1]
  route_table_id = aws_route_table.postechfiap_pvt_routetable.id
}
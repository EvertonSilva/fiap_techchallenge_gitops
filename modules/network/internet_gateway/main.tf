resource "aws_internet_gateway" "postechfiap_igw" {
  vpc_id = var.vpc_id

  tags = {
    Name = "PosTechFiapInternetGateway"
  }
}
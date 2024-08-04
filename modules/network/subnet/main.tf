### AZ 1a ###
resource "aws_subnet" "postechfiap_pubsubnet_1a" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.public_cidr_block
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "PosTechFiapPublicSubnetAz1a"
    "kubernetes.io/role/elb" = 1
  }
}

resource "aws_subnet" "postechfiap_pvtsubnet_1a" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.private_cidr_block
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1a"

  tags = {
    Name = "PosTechFiapPrivateSubnetAz1a"
    "kubernetes.io/role/internal-elb" = 1
  }
}

### AZ 1c ###
resource "aws_subnet" "postechfiap_pubsubnet_1c" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1c"

  tags = {
    Name = "PosTechFiapPublicSubnetAz1c"
    "kubernetes.io/role/elb" = 1
  }
}

resource "aws_subnet" "postechfiap_pvtsubnet_1c" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.200.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1c"

  tags = {
    Name = "PosTechFiapPrivateSubnetAz1c"
    "kubernetes.io/role/internal-elb" = 1
  }
}
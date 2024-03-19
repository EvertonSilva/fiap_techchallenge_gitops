
variable "common_tags" {}

resource "aws_vpc" "postech_fiap_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = merge(
    var.common_tags,
    { Name = "vpc-postech-project" }
  )
}

resource "aws_iam_role" "cluster_role" {
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "eks.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
  })

  tags = merge(
    var.common_tags,
    { Name = "eks-cluster-iam-role" }
  )
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.postech_fiap_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = merge(
    var.common_tags,
    { Name = "postech-fiap-eks-subnet-az-B" }
  )
}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.postech_fiap_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1b"

  tags = merge(
    var.common_tags,
    { Name = "postech-fiap-eks-subnet-az-A" }
  )
}

resource "aws_internet_gateway" "postech_fiap_igw" {
  vpc_id = aws_vpc.postech_fiap_vpc.id

  tags = merge(
    var.common_tags,
    { Name = "postech-fiap-internet-gateway" }
  )
}

resource "aws_nat_gateway" "postech_fiap_nat_gateway" {
  allocation_id = aws_eip.postech_fiap_eip.id
  subnet_id     = aws_subnet.private.id

  depends_on = [aws_internet_gateway.postech_fiap_igw]

  tags = merge(
    var.common_tags,
    { Name = "postech-nat-gateway-az-A" }
  )
}

resource "aws_nat_gateway" "postech_fiap_nat_gateway_b" {
  allocation_id = aws_eip.postech_fiap_eip_b.id
  subnet_id     = aws_subnet.private_b.id

  depends_on = [aws_internet_gateway.postech_fiap_igw]

  tags = merge(
    var.common_tags,
    { Name = "postech-nat-gateway-az-B" }
  )
}

resource "aws_eip" "postech_fiap_eip" {
  domain = "vpc"

  depends_on = [aws_internet_gateway.postech_fiap_igw]

  tags = merge(
    var.common_tags,
    { Name = "elastic-ip-natgw-az-A" }
  )
}

resource "aws_eip" "postech_fiap_eip_b" {
  domain = "vpc"

  depends_on = [aws_internet_gateway.postech_fiap_igw]

  tags = merge(
    var.common_tags,
    { Name = "elastic-ip-natgw-az-B" }
  )
}

resource "aws_security_group" "cluster_sg" {
  name = "eks-cluster-secgr"
  description = "Regras de acesso ao cluster EKS"
  vpc_id      = aws_vpc.postech_fiap_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.common_tags,
    {Name = "eks-cluster-secgr" }
  )
}

resource "aws_eks_cluster" "postech_fiap_eks" {
  name     = "postech-eks"
  role_arn = aws_iam_role.cluster_role.arn
  version  = "1.29"

  vpc_config {
    subnet_ids         = [
      aws_subnet.private.id,
      aws_subnet.private_b.id,
    ]
    security_group_ids = [aws_security_group.cluster_sg.id]
    endpoint_private_access = true
    endpoint_public_access  = false
  }

  tags = merge(
    var.common_tags,
    { Name = "eks-cluster" }
  )
}


output "cluster_name" {
  value = aws_eks_cluster.postech_fiap_eks.name
}
output "cluster_security_group_id" {
  value = one(aws_eks_cluster.postech_fiap_eks.vpc_config[0].security_group_ids)
}

output "postech_fiap_vpc_id" {
    value = aws_vpc.postech_fiap_vpc.id
}

output "subnets_eks" {
  value = [
    aws_subnet.private.id,
    aws_subnet.private_b.id
  ]
}

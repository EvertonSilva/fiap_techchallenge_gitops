
resource "aws_vpc" "postech_fiap_vpc" {
    cidr_block = "10.0.0.0/16"

    tags = {
        Environment = "Production"
        Project     = "PosTechFiap"
    }
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

    tags = {
      Environment = "Production"
      Project     = "PosTechFiap"
    }
}

resource "aws_subnet" "private" {
    vpc_id            = aws_vpc.postech_fiap_vpc.id
    cidr_block        = "10.0.1.0/24"
    availability_zone = "us-east-1a"

    tags = {
        Environment = "Production"
        Project     = "PosTechFiap"
    }
}

resource "aws_subnet" "private_b" {
    vpc_id            = aws_vpc.postech_fiap_vpc.id
    cidr_block        = "10.0.4.0/24"
    availability_zone = "us-east-1b"

    tags = {
        Environment = "Production"
        Project     = "PosTechFiap"
    }
}

resource "aws_security_group" "cluster_sg" {
  description = "Permite acesso entre EKS e RDS"
  vpc_id      = aws_vpc.postech_fiap_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
  }

  tags = {
    Environment = "Production"
    Project     = "PosTechFiap"
  }
}

resource "aws_eks_cluster" "postech_fiap_eks" {
    name     = "posTechFiapEKS"
    role_arn = aws_iam_role.cluster_role.arn
    version  = "1.27"

    vpc_config {
        subnet_ids         = [
          aws_subnet.private.id,
          aws_subnet.private_b.id,
        ]
        security_group_ids = [aws_security_group.cluster_sg.id]
        endpoint_private_access = true
        endpoint_public_access  = false
    }
    enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

    tags = {
        Environment = "Production"
        Project     = "PosTechFiap"
    }
}

output "cluster_security_group_id" {
  value = one(aws_eks_cluster.postech_fiap_eks.vpc_config[0].security_group_ids)
}

output "postech_fiap_vpc_id" {
    value = aws_vpc.postech_fiap_vpc.id
}

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
  name = "postech-eks-sg"
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

  egress {
    from_port       = 1024
    to_port         = 65535
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

# Worker Nodes Config
resource "aws_security_group" "eks_nodes" {
  description = "Security group for all nodes in the cluster"
  vpc_id = aws_vpc.postech_fiap_vpc.id
  
  ingress {
    from_port = 0
    to_port   = 65535
    protocol  = "-1"
  }

  ingress {
    from_port = 1025
    to_port   = 65535
    protocol  = "tcp"
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
  }

  tags = {
    Environment = "Production"
    Project     = "PosTechFiap"
  }
}

resource "aws_eks_node_group" "postechfiap_eks_node_group" {
  cluster_name = aws_eks_cluster.postech_fiap_eks.name
  node_group_name = "postechfiap-eks-nodegroup"
  node_role_arn   = aws_iam_role.node_role.arn
  subnet_ids      = [
    aws_subnet.private.id,
    aws_subnet.private_b.id
  ]

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.node_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node_AmazonEC2ContainerRegistryReadOnly
  ]

  tags = {
    Environment = "Production"
    Project     = "PosTechFiap"
  }
}

resource "aws_iam_role" "node_role" {
  name = "postech-fiap-worker-role"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Action":  "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "node_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node_role.name
}

resource "aws_iam_role_policy_attachment" "node_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node_role.name
}

resource "aws_iam_role_policy_attachment" "node_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node_role.name
}

resource "aws_iam_role_policy_attachment" "node_AmazonEBSCSIDriverPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.node_role.name
}
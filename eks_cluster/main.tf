
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
  allocation_id = aws_eip.postech_fiap_eip.id
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
    { Name = "postech-fiap-elastic-ip" }
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

output "cluster_security_group_id" {
  value = one(aws_eks_cluster.postech_fiap_eks.vpc_config[0].security_group_ids)
}

output "postech_fiap_vpc_id" {
    value = aws_vpc.postech_fiap_vpc.id
}

# Worker Nodes Config
resource "aws_eks_node_group" "postechfiap_eks_node_group" {
  cluster_name = aws_eks_cluster.postech_fiap_eks.name
  node_group_name = "postechfiap-eks-nodegroup"
  node_role_arn   = aws_iam_role.node_role.arn
  
  subnet_ids      = [
    aws_subnet.private.id,
    aws_subnet.private_b.id
  ]

  disk_size = 20
  instance_types = ["t2.micro"]

  scaling_config {
    desired_size = 1
    max_size     = 3
    min_size     = 1
  }

  depends_on = [
    aws_eks_cluster.postech_fiap_eks,
    aws_iam_role.node_role,
    aws_iam_role_policy_attachment.node_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node_AmazonEC2ContainerRegistryReadOnly
  ]

  tags = merge(
    var.common_tags,
    { Name = "eks-cluster-nodegroup" }
  )
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

  tags = merge(
    var.common_tags,
    { Name = "eks-node-iam-role" }
  )
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
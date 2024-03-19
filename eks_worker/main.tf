# Worker Nodes Config

variable "cluster_name" {}
variable "subnets" {}
variable "common_tags" {}


resource "aws_eks_node_group" "postechfiap_eks_node_group" {
  cluster_name = var.cluster_name
  node_group_name = "postechfiap-eks-nodegroup"
  node_role_arn   = aws_iam_role.node_role.arn
  
  subnet_ids = var.subnets

  capacity_type = "SPOT"
  disk_size = 20
  instance_types = ["t2.micro"]

  scaling_config {
    desired_size = 1
    max_size     = 3
    min_size     = 1
  }

  depends_on = [
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
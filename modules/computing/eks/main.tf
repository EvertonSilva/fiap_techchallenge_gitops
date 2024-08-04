
resource "aws_security_group_rule" "postechfiap_eks_ingress_rule" {
  type = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
  from_port = 80
  to_port = 80
  protocol = "tcp"

  security_group_id = aws_eks_cluster.postechfiap_eks.vpc_config[0].cluster_security_group_id
}

resource "aws_security_group_rule" "postechfiap_eks_egress_rule" {
  type = "egress"
  cidr_blocks = ["0.0.0.0/0"]
  from_port = 0
  to_port = 0
  protocol = "-1"

  security_group_id = aws_eks_cluster.postechfiap_eks.vpc_config[0].cluster_security_group_id
}

resource "aws_eks_cluster" "postechfiap_eks" {
  name      = "postechfiap_eks"
  role_arn  = aws_iam_role.postechfiap_eks_master_role.arn
  version   = "1.29"

  vpc_config {
    subnet_ids = var.private_subnets
    security_group_ids = []
    endpoint_private_access = true
    endpoint_public_access = false
  }

  depends_on = [
    aws_iam_role_policy_attachment.postechfiap_eks_cluster_policy,
    aws_iam_role_policy_attachment.postech_eks_service_policy,
  ]

  tags = {
    Name = "PosTechFiapEKSCluster"
  }
}

resource "aws_eks_node_group" "postechfiap_eks_nodegroup" {
  cluster_name      = aws_eks_cluster.postechfiap_eks.name
  node_group_name   = "postechfiap_eks_nodegroup"
  node_role_arn     = aws_iam_role.postechfiap_eks_node_role.arn
  subnet_ids        = var.private_subnets

  capacity_type     = "SPOT"
  disk_size         = 20
  instance_types    = [ "t2.micro", "t3.micro" ]

  scaling_config {
    desired_size    = 2
    max_size        = 3
    min_size        = 1
  }

  depends_on = [ 
    aws_iam_role_policy_attachment.postechfiap_eks_worker_node_policy,
    aws_iam_role_policy_attachment.postechfiap_eks_cni_policy,
    aws_iam_role_policy_attachment.postechfiap_eks_registry_readonly_policy
  ]
  
  tags = {
    Name = "PosTechFiapEKSClusterNodeGroup"
  }
}
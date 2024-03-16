
resource "aws_iam_role" "cluster_role" {
    name = "postech-fiap-eks-role"
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
}

resource "aws_eks_cluster" "postech_fiap_eks" {
    name     = "postech-fiap-eks"
    role_arn = aws_iam_role.cluster_role.arn
    version  = "1.27"

    vpc_config {
        subnet_ids         = aws_subnet.private[*].id
        security_group_ids = [aws_security_group.cluster_sg.id]
        endpoint_private_access = true
        endpoint_public_access  = false
    }
    enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

    tags = {
        Ambiente = "Production"
        Projeto  = "PosTechFiap"
    }
}

output "cluster_security_group_id" {
  value = aws_eks_cluster.main.vpc_config[0].security_group_ids[0]
}
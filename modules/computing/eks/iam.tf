resource "aws_iam_role" "postechfiap_eks_master_role" {
    name = "postechfiap-eks-master-role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
                Service = "eks.amazonaws.com"
            }
        }]
    })
}

resource "aws_iam_role" "postechfiap_eks_node_role" {
    name = "postechfiap-eks-node-role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
                Service = "ec2.amazonaws.com"
            }
        }]
    })
}

resource "aws_iam_role_policy_attachment" "postechfiap_eks_cluster_policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    role = aws_iam_role.postechfiap_eks_master_role.name
}

resource "aws_iam_role_policy_attachment" "postech_eks_service_policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
    role = aws_iam_role.postechfiap_eks_master_role.name
}

resource "aws_iam_role_policy_attachment" "postechfiap_eks_worker_node_policy" {
    policy_arn  = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    role        = aws_iam_role.postechfiap_eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "postechfiap_eks_cni_policy" {
    policy_arn  = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    role        = aws_iam_role.postechfiap_eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "postechfiap_eks_registry_readonly_policy" {
    policy_arn  = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    role        = aws_iam_role.postechfiap_eks_node_role.name
}
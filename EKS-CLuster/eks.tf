resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids              = module.networking.public_subnets
    security_group_ids      = [aws_security_group.eks_cluster_sg.id, aws_security_group.eks_worker_sg.id]
    endpoint_private_access = true
    endpoint_public_access  = true
  }


  enabled_cluster_log_types = ["api", "audit", "authenticator"]

  tags = var.tags
}

resource "aws_eks_node_group" "worker_node_group" {
  cluster_name    = var.cluster_name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.eks_worker_node_role.arn
  subnet_ids      = module.networking.private_subnets

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }
  instance_types = var.instance_types

  update_config {
    max_unavailable = 1
  }

  depends_on = [

    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]

}
output "cluster_role_arn" {
  value = aws_iam_role.eks_cluster_iam_role.arn
}


output "eks_cluster_AmazonEKSClusterPolicy" {
  value = aws_iam_policy_attachment.eks_cluster_policies
}

output "eks_cluster_AmazonEKSVpcResourceController" {
  value = aws_iam_policy_attachment.eks_cluster_vpc_resource_controller
}
output "alb_controller_role_arn" {
  value = aws_iam_role.alb_controller_role.arn
}

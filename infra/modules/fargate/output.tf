output "fargate_profile_name" {
  value = aws_eks_fargate_profile.eks_fargate_profile.fargate_profile_name
}

output "fargate_pods_sg_id" {
  value = aws_security_group.fargate_pods_sg.id     
}


# resource "aws_eks_fargate_profile" "eks_fargate_profile" {
#   cluster_name           = var.cluster_name
#   fargate_profile_name   = "${var.project_name}-fp"
#   pod_execution_role_arn = var.pod_execution_role_arn
#   subnet_ids            = [var.subnet_id_1, var.subnet_id_2]
  
#   # CoreDNS selector (specific label targeting)
#   selector {
#     namespace = "kube-system"
#     labels = {
#       k8s-app = "kube-dns"
#     }
#   }
  
#   # AWS Load Balancer Controller selector
#   selector {
#     namespace = "kube-system"
#     labels = {
#       "app.kubernetes.io/name" = "aws-load-balancer-controller"
#     }
#   }

#   selector {
#     namespace = "kube-system"
#   }
  
#   # Your application namespace
#   selector {
#     namespace = "prod-team"
#   }
# }



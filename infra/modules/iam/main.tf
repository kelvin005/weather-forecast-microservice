###################################
# EKS Cluster Role 
###################################
resource "aws_iam_role" "eks_cluster_iam_role" {
  name = "${var.project_name}-eks-cluster-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "eks.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy_attachment" "eks_cluster_policies" {
  name       = "${var.project_name}-eks-cluster-policies"
  roles      = [aws_iam_role.eks_cluster_iam_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_policy_attachment" "eks_cluster_vpc_resource_controller" {
  name       = "${var.project_name}-eks-cluster-vpc-controller"
  roles      = [aws_iam_role.eks_cluster_iam_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVpcResourceController"
}

# ----------------------------
# OIDC Provider for EKS Cluster
# ----------------------------
data "aws_eks_cluster" "this" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "this" {
  name = var.cluster_name
}

resource "aws_iam_openid_connect_provider" "eks" {
  url             = data.aws_eks_cluster.this.identity[0].oidc[0].issuer
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da0afd10df6"] # AWS root CA
}

# ----------------------------
# IAM Role for AWS Load Balancer Controller
# ----------------------------
resource "aws_iam_role" "alb_controller_role" {
  name = "${var.project_name}-alb-controller-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = aws_iam_openid_connect_provider.eks.arn
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "${replace(data.aws_eks_cluster.this.identity[0].oidc[0].issuer, "https://", "")}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller"
          }
        }
      }
    ]
  })
}

# ----------------------------
# IAM Policy for ALB Controller
# ----------------------------
resource "aws_iam_policy" "alb_controller" {
  name        = "${var.project_name}-ALBControllerPolicy"
  description = "Policy for AWS Load Balancer Controller"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action = [
          "acm:DescribeCertificate",
          "acm:ListCertificates", 
          "acm:GetCertificate",
          "ec2:*",
          "elasticloadbalancing:*",
          "iam:CreateServiceLinkedRole",
          "iam:GetServerCertificate",
          "iam:ListServerCertificates",
          "cognito-idp:DescribeUserPoolClient",
          "wafv2:*",
          "shield:*",
          "tag:GetResources",
          "tag:TagResources"
        ],
        Resource = "*"
      }
    ]
  })
}

# ----------------------------
# Attach Policy to Role
# ----------------------------
resource "aws_iam_role_policy_attachment" "alb_controller_attach" {
  role       = aws_iam_role.alb_controller_role.name
  policy_arn = aws_iam_policy.alb_controller.arn
}

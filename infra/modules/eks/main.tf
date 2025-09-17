
resource "aws_eks_cluster" "eks_cluster" {
  name     = "${var.project_name}-eks"
  role_arn = var.cluster_role_arn
  version  = var.cluster_version

  vpc_config {
    subnet_ids              = [var.private_subnet_id_1, var.private_subnet_id_2, var.public_subnet_id_1, var.public_subnet_id_2]
    
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  enabled_cluster_log_types = ["api", "audit", "authenticator"]
}


data "aws_eks_cluster_auth" "cluster_auth" {
  name = aws_eks_cluster.eks_cluster.name
}




# Ingress rule for ALB -> Pods (port 80)


# Ingress rule for ALB -> Pods (port 8080)




# EKS Managed Node Group
resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "${var.project_name}-node-group"
  node_role_arn   = aws_iam_role.node_group_role.arn
  subnet_ids      = [var.private_subnet_id_1, var.private_subnet_id_2]

  capacity_type  = "ON_DEMAND"
  instance_types = ["t3.medium"]

  scaling_config {
    desired_size = 2
    max_size     = 4
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.node_group_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node_group_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node_group_AmazonEC2ContainerRegistryReadOnly,
  ]

  tags = {
    Name = "${var.project_name}-node-group"
  }
}

# IAM role for the EKS node group
resource "aws_iam_role" "node_group_role" {
  name = "${var.project_name}-node-group-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "node_group_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node_group_role.name
}

resource "aws_iam_role_policy_attachment" "node_group_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node_group_role.name
}

resource "aws_iam_role_policy_attachment" "node_group_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node_group_role.name
}

# Security group for worker nodes
resource "aws_security_group" "node_group_sg" {
  name        = "${var.project_name}-node-group-sg"
  description = "Security group for EKS node group"
  vpc_id      = var.vpc_id

  # Allow nodes to communicate with each other
  ingress {
    from_port = 0
    to_port   = 65535
    protocol  = "tcp"
    self      = true
  }

  # Allow worker Kubelets and pods to receive communication from the cluster control plane
  ingress {
    from_port       = 1025
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [aws_eks_cluster.eks_cluster.vpc_config[0].cluster_security_group_id]
  }

  # Allow ALB to reach pods on nodes
  

  

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-node-group-sg"
  }
}

# Update the cluster security group to allow communication from worker nodes
resource "aws_security_group_rule" "cluster_ingress_workstation_https" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.node_group_sg.id
  security_group_id        = aws_eks_cluster.eks_cluster.vpc_config[0].cluster_security_group_id
}

# Optional: You can scale down or remove the Fargate profile
# Comment out or remove the aws_eks_fargate_profile resource in your current setup
# Or set desired capacity to 0 if you want to keep it for future use



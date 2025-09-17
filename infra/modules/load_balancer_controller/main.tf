# # main.tf (or wherever your service account is defined

# # Security Group for ALB
# resource "aws_security_group" "alb_sg" {
#   name        = "alb-sg"
#   description = "Allow HTTP access to ALB"
#   vpc_id      = var.vpc_id

#   ingress {
#     description = "Allow HTTP from anywhere"
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "weather-app-alb-sg"
#   }
# }

# # Security Group for EKS Pods - IMPORTANT: Allow ALB to reach pods
# resource "aws_security_group" "eks_pods_sg" {
#   name        = "eks-pods-sg"
#   description = "Allow ALB to reach EKS pods"
#   vpc_id      = var.vpc_id

#   ingress {
#     description     = "Allow ALB to reach backend pods"
#     from_port       = 8080
#     to_port         = 8080
#     protocol        = "tcp"
#     security_groups = [aws_security_group.alb_sg.id]
#   }

#   ingress {
#     description     = "Allow ALB to reach frontend pods"
#     from_port       = 80
#     to_port         = 80
#     protocol        = "tcp"
#     security_groups = [aws_security_group.alb_sg.id]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "weather-app-pods-sg"
#   }
# }

# # Application Load Balancer
# resource "aws_lb" "app_alb" {
#   name               = "weather-app-alb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.alb_sg.id]
#   subnets            = var.public_subnet_ids

#   enable_deletion_protection = false

#   tags = {
#     Name = "weather-app-alb"
#   }
# }

# # Target Group for Frontend
# resource "aws_lb_target_group" "frontend_tg" {
#   name        = "frontend-tg"
#   port        = 80
#   protocol    = "HTTP"
#   vpc_id      = var.vpc_id
#   target_type = "ip" # required for Fargate

#   health_check {
#     enabled             = true
#     healthy_threshold   = 3
#     interval            = 30
#     matcher             = "200"
#     path                = "/"
#     port                = "traffic-port"
#     protocol            = "HTTP"
#     timeout             = 5
#     unhealthy_threshold = 2
#   }

#   tags = {
#     Name = "frontend-tg"
#   }
# }

# # Target Group for Backend
# resource "aws_lb_target_group" "backend_tg" {
#   name        = "backend-tg"
#   port        = 8080
#   protocol    = "HTTP"
#   vpc_id      = var.vpc_id
#   target_type = "ip" # required for Fargate

#   health_check {
#     enabled             = true
#     healthy_threshold   = 3
#     interval            = 30
#     matcher             = "200"
#     path                = "/api/health"  # Make sure this endpoint exists!
#     port                = "traffic-port"
#     protocol            = "HTTP"
#     timeout             = 5
#     unhealthy_threshold = 2
#   }

#   tags = {
#     Name = "backend-tg"
#   }
# }

# # Listener (port 80)
# resource "aws_lb_listener" "http" {
#   load_balancer_arn = aws_lb.app_alb.arn
#   port              = "80"
#   protocol          = "HTTP"

#   # Default action - redirect to frontend
#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.frontend_tg.arn
#   }
# }

# # Rule: "/api/*" → Backend (higher priority)
# resource "aws_lb_listener_rule" "backend_rule" {
#   listener_arn = aws_lb_listener.http.arn
#   priority     = 100

#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.backend_tg.arn
#   }

#   condition {
#     path_pattern {
#       values = ["/api/*"]
#     }
#   }
# }


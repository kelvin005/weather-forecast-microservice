output "frontend_target_group_arn" {
  value = aws_lb_target_group.frontend_tg.arn
}

output "backend_target_group_arn" {
  value = aws_lb_target_group.backend_tg.arn
}

output "alb_security_group_id" {
  value = aws_security_group.alb_sg.id
}
# Output the ALB DNS name
output "alb_dns_name" {
  value = aws_lb.app_alb.dns_name
}

# Output target group ARNs for your Kubernetes services
output "frontend_target_group" {
  value = aws_lb_target_group.frontend_tg.arn
}

output "backend_target_group" {
  value = aws_lb_target_group.backend_tg.arn
}

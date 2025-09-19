output "region" {
  value = var.region
}

output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "ecr_registry" {
  value = module.ecr.repository_url
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "project_name" {
  value = "weather-forcast-application"
}


output "alb_role_arn" {
  value = module.iam.alb_controller_role_arn
}




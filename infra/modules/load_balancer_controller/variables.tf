# modules/alb/variables.tf

variable "project_name" {
  description = "Name of the project"
  type        = string
}


variable "vpc_id" {
  description = "VPC ID where ALB will be created"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for ALB"
  type        = list(string)
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection for ALB"
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {}
}
variable "eks_cluster_name" {
  description = "EKS Cluster Name"
  type        = string
}
variable "alb_controller_role_arn" {
  description = "ARN of the IAM Role for ALB Controller"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet IDs"
  type        = list(string)
}





variable "project_name" {
  description = "A short name used to tag/name resources"
  type        = string
  default     = "weather-forecast-microservices"
}

variable "region" {
  description = "AWS region to deploy to"
  type        = string
  default     = "us-east-2"
}

variable "cluster_version" {
  description = "EKS Kubernetes version"
  type        = string
  default     = "1.33"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.12.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.24"
    }
  }

  backend "s3" {
    bucket         = "eks-backend-tf-bucket"
    key            = "terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "eks-backend-tf-table"
    encrypt        = true
  }
}

provider "aws" {
  region = var.region
}


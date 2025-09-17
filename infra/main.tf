


module "vpc" {
  source = "./modules/vpc"
  project_name = var.project_name

}

module "iam" {
  source       = "./modules/iam"
  project_name = var.project_name
  eks_cluster_name = var.project_name
  cluster_name = module.eks.cluster_name
}


resource "null_resource" "iam_policy_dependency" {
  depends_on = [
    module.iam.eks_cluster_AmazonEKSClusterPolicy,
    module.iam.eks_cluster_AmazonEKSVpcResourceController
  ]
}


module "eks" {
  source              = "./modules/eks"
  project_name        = var.project_name
  cluster_version     = var.cluster_version
  cluster_role_arn    = module.iam.cluster_role_arn
  private_subnet_id_1 = module.vpc.private_subnet_id_1
  private_subnet_id_2 = module.vpc.private_subnet_id_2
  vpc_id              = module.vpc.vpc_id
  public_subnet_id_1  = module.vpc.public_subnet_id_1
  public_subnet_id_2  = module.vpc.public_subnet_id_2


  depends_on = [ 
    module.vpc, 
    null_resource.iam_policy_dependency
  ]
  
}

# module "fargate" {
#   source                   = "./modules/fargate"
#   project_name             = var.project_name
#   cluster_name             = module.eks.cluster_name
#   pod_execution_role_arn   = module.iam.fargate_pod_execution_role_arn
#   subnet_id_1             = module.vpc.private_subnet_id_1
#   subnet_id_2             = module.vpc.private_subnet_id_2
#   depends_on = [ module.eks.eks_cluster, module.iam.fargate_pod_execution_role ]
#   vpc_id                   = module.vpc.vpc_id
# }

module "ecr" {
  source       = "./modules/ecr"
  project_name = var.project_name
}

# module "load_balancer_controller" {
#   source = "./modules/load_balancer_controller"

#   project_name       = var.project_name
#   vpc_id             = module.vpc.vpc_id
#   public_subnet_ids  = [module.vpc.public_subnet_id_1, module.vpc.public_subnet_id_2]
#   eks_cluster_name   = module.eks.cluster_name
#   alb_controller_role_arn = module.iam.alb_controller_role_arn
#   public_subnets = [module.vpc.public_subnet_id_1, module.vpc.public_subnet_id_2]
# }


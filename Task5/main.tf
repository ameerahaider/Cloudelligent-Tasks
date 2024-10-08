provider "aws" {
  region = var.region
  profile = "AWSAdministratorAccess-905418229977"

}

module "vpc" {
  source = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
  name_prefix = var.name_prefix
  public_subnets = var.public_subnets
  private_subnets = var.private_subnets
  availability_zones = var.availability_zones
}

module "sg" {
  source = "./modules/sg"
  vpc_id = module.vpc.vpc_id
  name_prefix = var.name_prefix
}

//ALB
module "alb" {
  source = "./modules/alb"
  vpc_id = module.vpc.vpc_id
  security_group_id = module.sg.alb-sg
  public_subnet_ids = module.vpc.public_subnets_ids
  name_prefix = var.name_prefix
}

//EFS
module "efs" {
  source = "./modules/efs"
  name_prefix = var.name_prefix
  private_subnets_ids = module.vpc.private_subnets_ids
  efs_security_group_id = module.sg.efs-sg
}

module "ecs_cluster" {
  source = "./modules/ecs_cluster"
  name_prefix = var.name_prefix
}

module "ecs_task_definition" {
  source = "./modules/ecs_task_definition"
  name_prefix = var.name_prefix
  cpu = "256"
  memory = "512"
  image = "nginx"
  region = var.region
  efs_id = module.efs.efs_id
}

module "ecs_service" {
  source = "./modules/ecs_service"
  name_prefix = var.name_prefix
  cluster_id = module.ecs_cluster.ecs_cluster_id
  task_definition_arn = module.ecs_task_definition.task_definition_arn
  desired_count = 1
  private_subnets_id = module.vpc.private_subnets_ids
  ecs_security_group_id = module.sg.ecs-sg
  target_group_arn = module.alb.alb_target_group_arn
}
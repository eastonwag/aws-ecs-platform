module "networking" {
  source = "./modules/networking"
  project_name         = var.project_name
  vpc_cidr             = var.vpc_cidr
  public_subnet_1_cidr = var.public_subnet_1_cidr
  public_subnet_2_cidr = var.public_subnet_2_cidr
  az_1 = var.az_1
  az_2 = var.az_2
}

module "security" {
  source       = "./modules/security"
  project_name = var.project_name
  vpc_id       = module.networking.vpc_id
}

module "database" {
  source            = "./modules/database"
  project_name      = var.project_name
  public_subnet_ids = [
    module.networking.public_subnet_1_id,
    module.networking.public_subnet_2_id
  ]
  rds_sg_id = module.security.rds_sg_id
}

module "alb" {
  source            = "./modules/alb"
  project_name      = var.project_name
  vpc_id            = module.networking.vpc_id
  public_subnet_ids = [
    module.networking.public_subnet_1_id,
    module.networking.public_subnet_2_id
  ]
  alb_sg_id = module.security.alb_sg_id
}

module "compute" {
  source            = "./modules/compute"
  project_name      = var.project_name
  aws_region        = var.aws_region
  aws_account_id    = var.aws_account_id
  public_subnet_ids = [
    module.networking.public_subnet_1_id,
    module.networking.public_subnet_2_id
  ]
  ecs_sg_id        = module.security.ecs_sg_id
  db_host          = module.database.db_host
  target_group_arn = module.alb.target_group_arn
}
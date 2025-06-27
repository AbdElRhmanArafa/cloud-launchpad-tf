module "vpc" {
  source = "./modules/network"
  project_name = var.project_name
  vpc_cidr_block = var.vpc_cidr_block
  subnets_list = var.subnets_list
}

module "computer" {
  source  = "./modules/computer"
  subnets = { for k, v in module.vpc.subnets_list : k => v }
  vpc_id  = module.vpc.vpc_id
  project_name = var.project_name
}
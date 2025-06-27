module "vpc" {
  source = "./modules/network"
  project_name = var.project_name
  vpc_cidr_block = var.vpc_cidr_block
  subnets_list = var.subnets_list
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref=tags/0.17.0"

  cidr_block = "172.16.0.0/16"

  context = module.this.context
}

module "subnets" {
  source = "../../"

  context = module.this.context

  availability_zone = var.availability_zone
  vpc_id            = module.vpc.vpc_id
  igw_id            = module.vpc.igw_id
  cidr_block        = module.vpc.vpc_cidr_block
  subnet_names      = var.subnet_names
  max_subnets       = var.max_subnets
  nat_enabled       = var.nat_enabled
  type              = var.type
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source  = "cloudposse/vpc/aws"
  version = "0.18.1"

  cidr_block = "172.16.0.0/16"

  context = module.this.context
}

# Verify we can make a public subnet with NAT for private subnet
module "subnets" {
  source = "../../"

  context = module.this.context

  availability_zone = var.availability_zone
  vpc_id            = module.vpc.vpc_id
  igw_id            = module.vpc.igw_id
  cidr_block        = "172.16.128.0/17"
  subnet_names      = var.subnet_names
  max_subnets       = var.max_subnets
  nat_enabled       = true
  type              = "public"
}

# Verify we can make private subnets connected to the public subnet
module "subnets_private" {
  source = "../../"

  context = module.this.context

  availability_zone = var.availability_zone
  vpc_id            = module.vpc.vpc_id
  igw_id            = module.vpc.igw_id
  cidr_block        = "172.16.0.0/17"
  subnet_names      = ["private1"]
  max_subnets       = var.max_subnets
  nat_enabled       = false
  type              = "private"
  ngw_id            = module.subnets.ngw_id
}

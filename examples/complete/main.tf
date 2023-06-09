provider "aws" {
  region = var.region
}

module "vpc" {
  source  = "cloudposse/vpc/aws"
  version = "2.1.0"

  ipv4_primary_cidr_block = var.vpc_cidr_block

  context = module.this.context
}

# Verify we can make a public subnet with NAT for private subnet
module "subnets" {
  source  = "cloudposse/dynamic-subnets/aws"
  version = "2.3.0"

  availability_zones   = var.availability_zones
  vpc_id               = module.vpc.vpc_id
  igw_id               = [module.vpc.igw_id]
  ipv4_cidr_block      = [module.vpc.vpc_cidr_block]
  nat_gateway_enabled  = false
  nat_instance_enabled = false

  context = module.this.context
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

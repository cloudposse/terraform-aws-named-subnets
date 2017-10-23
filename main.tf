data "aws_vpc" "default" {
  id = "${var.vpc_id}"
}

locals {
  public_cidr_block  = "cidrsubnet(var.cidr_block, 1, 0)"
  private_cidr_block = "cidrsubnet(var.cidr_block, 1, 1)"
}

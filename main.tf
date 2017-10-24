data "aws_availability_zones" "available" {}

data "aws_vpc" "default" {
  id = "${var.vpc_id}"
}

locals {
  subnets_count = "${length(compact(var.names)) * length(compact(var.availability_zones))}"
}

data "aws_subnet_ids" "default" {
  vpc_id = "${var.vpc_id}"
}

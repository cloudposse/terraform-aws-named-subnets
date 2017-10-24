data "aws_availability_zones" "available" {}

data "aws_vpc" "default" {
  id = "${var.vpc_id}"
}

locals {
  subnets_count = "${length(compact(concat(var.public_subnets_names, var.private_subnets_names))) * length(compact(var.availability_zones))}"
}

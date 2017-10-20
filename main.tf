data "aws_availability_zones" "available" {}

data "aws_vpc" "default" {
  id = "${var.vpc_id}"
}

locals {
  subnets_count = "${length(compact(var.names)) * length(compact(var.availability_zones))}"
}

module "subnets_label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.2.2"
  namespace  = "${var.namespace}"
  name       = "${var.name}"
  stage      = "${var.stage}"
  delimiter  = "${var.delimiter}"
  attributes = "${var.attributes}"
  tags       = "${var.tags}"
}

resource "aws_subnet" "default" {
  count             = "${local.subnets_count}"
  vpc_id            = "${var.vpc_id}"
  availability_zone = "${element(var.availability_zones, count.index)}"
  cidr_block        = "${cidrsubnet(length(var.base_cidr) > 0 ? var.base_cidr : data.aws_vpc.default.cidr_block, ceil(log(local.subnets_count * 2, 2)), count.index)}"

  tags = {
    "Name"      = "${module.subnets_label.id}${var.delimiter}${element(var.names, count.index)}${var.delimiter}${element(var.availability_zones, count.index)}"
    "Stage"     = "${module.subnets_label.stage}"
    "Namespace" = "${module.subnets_label.namespace}"
  }
}

resource "aws_eip" "default" {
  count = "${var.nat_enabled == "true" ? local.subnets_count : 0}"
  vpc   = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_nat_gateway" "default" {
  count         = "${var.nat_enabled == "true" ? local.subnets_count : 0}"
  allocation_id = "${element(aws_eip.default.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.default.*.id, count.index)}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route_table" "default" {
  count  = "${local.subnets_count}"
  vpc_id = "${var.vpc_id}"
  tags   = "${module.subnets_label.tags}"
}

resource "aws_route" "default" {
  count                  = "${local.subnets_count}"
  route_table_id         = "${element(aws_route_table.default.*.id, count.index)}"
  nat_gateway_id         = "${replace(element(coalescelist(aws_nat_gateway.default.*.id, list("workaround")), count.index), "workaround", "")}"
  gateway_id             = "${var.igw_id}"
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route" "additional" {
  count                  = "${length(compact(values(var.additional_routes))) > 0 ? local.subnets_count : 0}"
  route_table_id         = "${element(aws_route_table.default.*.id, count.index)}"
  destination_cidr_block = "${element(coalescelist(keys(var.additional_routes), list("workaround")), count.index)}"
  gateway_id             = "${lookup(var.additional_routes, element(coalescelist(keys(var.additional_routes), list("workaround")), count.index), "workaround")}"
}

resource "aws_route_table_association" "default" {
  count          = "${local.subnets_count}"
  subnet_id      = "${element(aws_subnet.default.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.default.*.id, count.index)}"
}

resource "aws_network_acl" "default" {
  count      = "${signum(length(var.network_acl_id)) == 0 ? 1 : 0}"
  vpc_id     = "${data.aws_vpc.default.id}"
  subnet_ids = ["${aws_subnet.default.*.id}"]
  egress     = "${var.egress}"
  ingress    = "${var.ingress}"
  tags       = "${module.subnets_label.tags}"
}

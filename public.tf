locals {
  public_count = "${var.enabled == "true" && var.type == "public" ? length(var.subnet_names) : 0}"
}

module "public_label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.3.1"
  namespace  = "${var.namespace}"
  name       = "${var.name}"
  stage      = "${var.stage}"
  delimiter  = "${var.delimiter}"
  tags       = "${var.tags}"
  attributes = ["${compact(concat(var.attributes, list("public")))}"]
  enabled    = "${var.enabled}"
}

resource "aws_subnet" "public" {
  count             = "${local.public_count}"
  vpc_id            = "${var.vpc_id}"
  availability_zone = "${var.availability_zone}"
  cidr_block        = "${cidrsubnet(var.cidr_block, ceil(log(var.max_subnets, 2)), count.index)}"

  tags = {
    "Name"      = "${module.public_label.id}${var.delimiter}${element(var.subnet_names, count.index)}"
    "Stage"     = "${module.public_label.stage}"
    "Namespace" = "${module.public_label.namespace}"
    "Named"     = "${element(var.subnet_names, count.index)}"
    "Type"      = "${var.type}"
  }
}

resource "aws_route_table" "public" {
  count  = "${local.public_count}"
  vpc_id = "${var.vpc_id}"

  tags = {
    "Name"      = "${module.public_label.id}${var.delimiter}${element(var.subnet_names, count.index)}"
    "Stage"     = "${module.public_label.stage}"
    "Namespace" = "${module.public_label.namespace}"
  }
}

resource "aws_route" "public" {
  count                  = "${local.public_count}"
  route_table_id         = "${element(aws_route_table.public.*.id, count.index)}"
  gateway_id             = "${var.igw_id}"
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public" {
  count          = "${local.public_count}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.public.*.id, count.index)}"
}

resource "aws_network_acl" "public" {
  count      = "${var.enabled == "true" && var.type == "public" && signum(length(var.public_network_acl_id)) == 0 ? 1 : 0}"
  vpc_id     = "${data.aws_vpc.default.id}"
  subnet_ids = ["${aws_subnet.public.*.id}"]
  egress     = "${var.public_network_acl_egress}"
  ingress    = "${var.public_network_acl_ingress}"
  tags       = "${module.public_label.tags}"
}

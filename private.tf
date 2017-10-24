module "private_label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.2.2"
  namespace  = "${var.namespace}"
  name       = "${var.name}"
  stage      = "${var.stage}"
  delimiter  = "${var.delimiter}"
  attributes = ["private"]
  tags       = "${var.tags}"
}

resource "aws_subnet" "private" {
  count             = "${length(var.private_subnets_names) > 0 ? local.subnets_count : 0}"
  vpc_id            = "${var.vpc_id}"
  availability_zone = "${element(var.availability_zones, count.index)}"
  cidr_block        = "${cidrsubnet(length(var.base_cidr) > 0 ? var.base_cidr : data.aws_vpc.default.cidr_block, ceil(log(local.subnets_count * 2, 2)), count.index)}"

  tags = {
    "Name"      = "${module.private_label.id}${var.delimiter}${format("%v-%v", element(coalescelist(var.private_subnets_names, list("workaround")), count.index), element(var.availability_zones, count.index))}"
    "Stage"     = "${module.private_label.stage}"
    "Namespace" = "${module.private_label.namespace}"
    "AZ"        = "${element(var.availability_zones, count.index)}"
  }
}

resource "aws_route_table" "private" {
  count  = "${length(var.private_subnets_names) > 0 ? local.subnets_count : 0}"
  vpc_id = "${var.vpc_id}"
  tags   = "${module.private_label.tags}"
}

resource "aws_route" "private" {
  count                  = "${length(var.private_subnets_names) > 0 ? local.subnets_count : 0}"
  route_table_id         = "${element(coalescelist(aws_subnet.private.*.id, list("workaround")), count.index)}"
  nat_gateway_id         = "${element(var.ngw_ids, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route" "private_additional" {
  count                  = "${length(compact(values(var.additional_private_routes))) > 0 ? local.subnets_count : 0}"
  route_table_id         = "${element(coalescelist(aws_route_table.private.*.id, list("workaround")), count.index)}"
  destination_cidr_block = "${element(coalescelist(keys(var.additional_private_routes), list("workaround")), count.index)}"
  nat_gateway_id         = "${lookup(var.additional_private_routes, element(coalescelist(keys(var.additional_private_routes), list("workaround")), count.index), "workaround")}"
}

resource "aws_route_table_association" "private" {
  count          = "${length(var.private_subnets_names) > 0 ? local.subnets_count : 0}"
  subnet_id      = "${element(coalescelist(aws_subnet.private.*.id, list("workaround")), count.index)}"
  route_table_id = "${element(coalescelist(aws_route_table.private.*.id, list("workaround")), count.index)}"
}

resource "aws_network_acl" "private" {
  count      = "${signum(length(var.private_network_acl_id)) == 0  && length(var.private_subnets_names) > 0  ? 1 : 0}"
  vpc_id     = "${data.aws_vpc.default.id}"
  subnet_ids = ["${coalescelist(aws_subnet.private.*.id, list("workaround"))}"]
  egress     = "${var.private_network_acl_egress}"
  ingress    = "${var.private_network_acl_ingress}"
  tags       = "${module.private_label.tags}"
}

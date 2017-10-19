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
  count             = "${length(compact(var.private_cidr_blocks))}"
  vpc_id            = "${signum(length(var.vpc_id)) == 1 ? var.vpc_id : module.vpc.vpc_id}"
  availability_zone = "${signum(length(var.availability_zone)) == 1 ? var.availability_zone : data.aws_availability_zones.available.names[0]}"
  cidr_block        = "${element(var.private_cidr_blocks, count.index)}"

  tags = {
    "Name"      = "${module.private_label.id}${var.delimiter}${signum(length(var.availability_zone)) == 1 ? var.availability_zone : data.aws_availability_zones.available.names[0]}"
    "Stage"     = "${module.private_label.stage}"
    "Namespace" = "${module.private_label.namespace}"
  }
}

resource "aws_route_table" "private" {
  count  = "${length(compact(var.private_cidr_blocks))}"
  vpc_id = "${signum(length(var.vpc_id)) == 1 ? var.vpc_id : module.vpc.vpc_id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${signum(length(var.ngw_id)) == 1 ? var.ngw_id : aws_nat_gateway.default.id}"
  }

  tags = "${module.private_label.tags}"

  lifecycle {
    ignore_changes = ["route"]
  }

  depends_on = ["aws_nat_gateway.default"]
}

resource "aws_route" "private" {
  count                  = "${length(compact(values(var.additional_private_routes)))}"
  route_table_id         = "${element(aws_route_table.private.*.id, count.index)}"
  destination_cidr_block = "${element(coalescelist(keys(var.additional_private_routes), list("workaround")), count.index)}"
  gateway_id             = "${lookup(var.additional_private_routes, element(coalescelist(keys(var.additional_private_routes), list("workaround")), count.index), "workaround")}"
}

resource "aws_route_table_association" "private" {
  count          = "${length(compact(var.private_cidr_blocks))}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}

resource "aws_network_acl" "private" {
  count      = "${signum(length(var.private_network_acl_id)) == 0 ? 1 : 0}"
  vpc_id     = "${signum(length(var.vpc_id)) == 1 ? var.vpc_id : module.vpc.vpc_id}"
  subnet_ids = ["${aws_subnet.private.*.id}"]
  egress     = "${var.egress}"
  ingress    = "${var.ingress}"
  tags       = "${module.private_label.tags}"
}

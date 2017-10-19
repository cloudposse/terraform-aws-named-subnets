module "public_label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.2.2"
  namespace  = "${var.namespace}"
  name       = "${var.name}"
  stage      = "${var.stage}"
  delimiter  = "${var.delimiter}"
  attributes = ["public"]
  tags       = "${var.tags}"
}

resource "aws_subnet" "public" {
  count             = "${length(compact(var.public_cidr_blocks))}"
  vpc_id            = "${signum(length(var.vpc_id)) == 1 ? var.vpc_id : module.vpc.vpc_id}"
  availability_zone = "${signum(length(var.availability_zone)) == 1 ? var.availability_zone : data.aws_availability_zones.available.names[0]}"
  cidr_block        = "${element(var.public_cidr_blocks, count.index)}"

  tags = {
    "Name"      = "${module.public_label.id}${var.delimiter}${signum(length(var.availability_zone)) == 1 ? var.availability_zone : data.aws_availability_zones.available.names[0]}"
    "Stage"     = "${module.public_label.stage}"
    "Namespace" = "${module.public_label.namespace}"
  }
}

resource "aws_route_table" "public" {
  count  = "${length(compact(var.public_cidr_blocks))}"
  vpc_id = "${signum(length(var.vpc_id)) == 1 ? var.vpc_id : module.vpc.vpc_id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${signum(length(var.igw_id)) == 1 ? var.igw_id : aws_nat_gateway.default.id}"
  }

  tags = "${module.public_label.tags}"

  lifecycle {
    ignore_changes = ["route"]
  }

  depends_on = ["aws_nat_gateway.default"]
}

resource "aws_route" "public" {
  count                  = "${length(compact(values(var.additional_public_routes)))}"
  route_table_id         = "${element(aws_route_table.public.*.id, count.index)}"
  destination_cidr_block = "${element(coalescelist(keys(var.additional_public_routes), list("workaround")), count.index)}"
  gateway_id             = "${lookup(var.additional_public_routes, element(coalescelist(keys(var.additional_public_routes), list("workaround")), count.index), "workaround")}"
}

resource "aws_route_table_association" "public" {
  count          = "${length(compact(var.public_cidr_blocks))}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.public.*.id, count.index)}"
}

resource "aws_network_acl" "public" {
  count      = "${signum(length(var.public_network_acl_id)) == 0 ? 1 : 0}"
  vpc_id     = "${signum(length(var.vpc_id)) == 1 ? var.vpc_id : module.vpc.vpc_id}"
  subnet_ids = ["${aws_subnet.public.*.id}"]
  egress     = "${var.egress}"
  ingress    = "${var.ingress}"
  tags       = "${module.public_label.tags}"
}

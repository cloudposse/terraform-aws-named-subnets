module "public_subnet_label" {
  source    = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.2.0"
  namespace = "${var.namespace}"
  stage     = "${var.stage}"
  name      = "public"
  tags      = "${var.tags}"
}

resource "aws_subnet" "public" {
  count             = "${length(var.public_names)}"
  vpc_id            = "${data.aws_vpc.default.id}"
  availability_zone = "${var.public_availability_zone}"
  cidr_block        = "${cidrsubnet(local.public_cidr_block, ceil(log(length(var.public_names), 2)), count.index)}"

  tags = {
    "Name"      = "${module.public_subnet_label.namespace}${var.delimiter}${module.public_subnet_label.stage}${var.delimiter}${element(var.public_names, count.index)}"
    "Stage"     = "${module.public_subnet_label.stage}"
    "Namespace" = "${module.public_subnet_label.namespace}"
  }
}

resource "aws_route_table" "public" {
  count  = "${signum(length(var.vpc_default_route_table_id)) == 1 ? 0 : 1}"
  vpc_id = "${data.aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${var.igw_id}"
  }

  tags = "${module.public_subnet_label.tags}"
}

locals {
  route_table_id = "${coalesce(var.vpc_default_route_table_id, join("",aws_route_table.public.*.id))}"
}

resource "aws_route_table_association" "public" {
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${local.route_table_id}"
}

resource "aws_network_acl" "public" {
  count      = "${signum(length(var.public_network_acl_id)) == 0 ? 1 : 0}"
  vpc_id     = "${var.vpc_id}"
  subnet_ids = ["${aws_subnet.public.*.id}"]

  egress {
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
  }

  ingress {
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
  }

  tags = "${module.public_subnet_label.tags}"
}

resource "aws_eip" "default" {
  vpc = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_nat_gateway" "default" {
  allocation_id = "${aws_eip.default.id}"
  subnet_id     = "${element(aws_subnet.public.*.id, 0)}"

  lifecycle {
    create_before_destroy = true
  }
}

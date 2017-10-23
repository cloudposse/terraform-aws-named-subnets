module "private_subnet_label" {
  source    = "git::https://github.com/cloudposse/tf_label.git?ref=tags/0.2.0"
  namespace = "${var.namespace}"
  stage     = "${var.stage}"
  name      = "private"
}

resource "aws_subnet" "private" {
  count             = "${length(var.private_names)}"
  vpc_id            = "${data.aws_vpc.default.id}"
  availability_zone = "${var.private_availability_zone}"
  cidr_block        = "${cidrsubnet(private_cidr_block, ceil(log(length(var.private_names), 2)), count.index)}"

  tags = {
    "Name"      = "${module.private_subnet_label.namespace}${var.delimiter}${module.private_subnet_label.stage}${var.delimiter}${element(var.private_names, count.index)}"
    "Stage"     = "${module.private_subnet_label.stage}"
    "Namespace" = "${module.private_subnet_label.namespace}"
  }
}

resource "aws_route_table" "private" {
  count  = "${length(var.private_names)}"
  vpc_id = "${data.aws_vpc.default.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.default}"
  }

  tags = "${module.private_subnet_label.tags}"
}

resource "aws_route_table_association" "private" {
  count = "${length(var.private_names)}"

  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}

resource "aws_network_acl" "private" {
  count      = "${signum(length(var.private_network_acl_id)) == 0 ? 1 : 0}"
  vpc_id     = "${var.vpc_id}"
  subnet_ids = ["${aws_subnet.private.*.id}"]

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

  tags = "${module.private_subnet_label.tags}"
}

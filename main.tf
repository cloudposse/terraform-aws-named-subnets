module "vpc" {
  source     = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref=remove_subnets"
  name       = "${var.name}"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  create_vpc = "${signum(length(var.vpc_id)) == 1 ? 1 : 0}"
}

# Get object aws_vpc by vpc_id
data "aws_vpc" "default" {
  id = "${signum(length(var.vpc_id)) == 1 ? var.vpc_id : module.vpc.vpc_id}"
}

data "aws_availability_zones" "available" {}

resource "aws_eip" "default" {
  count = "${signum(length(var.ngw_id)) == 0 ? 1 : 0}"
  vpc   = true

  lifecycle {
    create_before_destroy = true
  }
}

#### Private

resource "aws_nat_gateway" "default" {
  count         = "${signum(length(var.ngw_id)) == 0 ? 1 : 0}"
  allocation_id = "${aws_eip.default.id}"
  subnet_id     = "${element(aws_subnet.private.*.id, count.index)}"

  lifecycle {
    create_before_destroy = true
  }

  depends_on = ["aws_subnet.private"]
}

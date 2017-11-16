locals {
  ngw_count = "${var.enabled == "true" && var.type == "public" && var.nat_enabled == "true" ? 1 : 0}"
}

resource "aws_eip" "default" {
  count = "${local.ngw_count}"
  vpc   = "true"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_nat_gateway" "default" {
  count         = "${local.ngw_count}"
  allocation_id = "${join("", aws_eip.default.*.id)}"
  subnet_id     = "${element(aws_subnet.public.*.id, 0)}"
  tags          = "${module.public_label.tags}"

  lifecycle {
    create_before_destroy = true
  }
}

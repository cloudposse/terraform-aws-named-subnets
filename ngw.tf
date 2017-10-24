resource "aws_eip" "default" {
  count = "${length(var.public_subnets_names) > 0 && var.nat_enabled == "true" ? local.subnets_count : 0}"
  vpc   = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_nat_gateway" "default" {
  count         = "${(length(var.public_subnets_names) > 0 && var.nat_enabled == "true") == "true" ? length(var.availability_zones) : 0}"
  allocation_id = "${element(aws_eip.default.*.id, count.index)}"
  subnet_id     = "${element(coalescelist(var.public_subnets_names, list("workaround")), count.index)}"

  lifecycle {
    create_before_destroy = true
  }
}

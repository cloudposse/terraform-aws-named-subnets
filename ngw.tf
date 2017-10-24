# locals {
#   route_table_public = "${coalescelist(aws_route_table.public.*.id, list("workaround"))}"
# }

# data "aws_subnet" "public" {
#   count = "${length(var.igw_id) > 0 ? length(var.availability_zones) : 0}"
#
#   filter {
#     name   = "tag:AZ"
#     values = "${element(var.availability_zones, count.index)}"
#   }
# }

resource "aws_eip" "default" {
  count = "${(length(var.igw_id) > 0 || var.nat_enabled == "true") == "true" ? local.subnets_count : 0}"
  vpc   = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_nat_gateway" "default" {
  count         = "${(length(var.igw_id) > 0 || var.nat_enabled == "true") == "true" ? length(var.availability_zones) : 0}"
  allocation_id = "${element(aws_eip.default.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"

  lifecycle {
    create_before_destroy = true
  }
}

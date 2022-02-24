locals {
  private_count = module.this.enabled && var.type == "private" ? length(var.subnet_names) : 0
}

module "private_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  attributes = ["private"]

  context = module.this.context
}

resource "aws_subnet" "private" {
  count                   = local.private_count
  vpc_id                  = var.vpc_id
  availability_zone       = var.availability_zone
  cidr_block              = cidrsubnet(var.cidr_block, ceil(log(var.max_subnets, 2)), count.index)
  map_public_ip_on_launch = var.map_public_ip_on_launch_enabled

  tags = merge(module.private_label.tags, {
    "Name"  = "${module.private_label.id}${module.this.delimiter}${element(var.subnet_names, count.index)}"
    "Named" = var.subnet_names[count.index]
    "Type"  = var.type
  }, var.tags)
}

resource "aws_route_table" "private" {
  count  = local.private_count
  vpc_id = var.vpc_id

  tags = merge(module.private_label.tags, {
    "Name" = "${module.private_label.id}${module.this.delimiter}${element(var.subnet_names, count.index)}"
  })
}

resource "aws_route" "private" {
  count                  = local.private_count
  route_table_id         = aws_route_table.private.*.id[count.index]
  network_interface_id   = var.eni_id == "" ? null : var.eni_id
  nat_gateway_id         = var.ngw_id == "" ? null : var.ngw_id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "private" {
  count          = local.private_count
  subnet_id      = aws_subnet.private.*.id[count.index]
  route_table_id = aws_route_table.private.*.id[count.index]
}

resource "aws_network_acl" "private" {
  count      = module.this.enabled && var.type == "private" && signum(length(var.private_network_acl_id)) == 0 ? 1 : 0
  vpc_id     = data.aws_vpc.default.id
  subnet_ids = aws_subnet.private.*.id

  dynamic "egress" {
    for_each = var.private_network_acl_egress
    content {
      action          = lookup(egress.value, "action", null)
      cidr_block      = lookup(egress.value, "cidr_block", null)
      from_port       = lookup(egress.value, "from_port", null)
      icmp_code       = lookup(egress.value, "icmp_code", null)
      icmp_type       = lookup(egress.value, "icmp_type", null)
      ipv6_cidr_block = lookup(egress.value, "ipv6_cidr_block", null)
      protocol        = lookup(egress.value, "protocol", null)
      rule_no         = lookup(egress.value, "rule_no", null)
      to_port         = lookup(egress.value, "to_port", null)
    }
  }

  dynamic "ingress" {
    for_each = var.private_network_acl_ingress
    content {
      action          = lookup(ingress.value, "action", null)
      cidr_block      = lookup(ingress.value, "cidr_block", null)
      from_port       = lookup(ingress.value, "from_port", null)
      icmp_code       = lookup(ingress.value, "icmp_code", null)
      icmp_type       = lookup(ingress.value, "icmp_type", null)
      ipv6_cidr_block = lookup(ingress.value, "ipv6_cidr_block", null)
      protocol        = lookup(ingress.value, "protocol", null)
      rule_no         = lookup(ingress.value, "rule_no", null)
      to_port         = lookup(ingress.value, "to_port", null)
    }
  }
  tags = module.private_label.tags
}

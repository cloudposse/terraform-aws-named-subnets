locals {
  private_subnets = var.enabled && var.type == "private" ? var.subnet_names : []
}

module "private_label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.15.0"
  namespace  = var.namespace
  name       = var.name
  stage      = var.stage
  delimiter  = var.delimiter
  tags       = var.tags
  attributes = compact(concat(var.attributes, ["private"]))
  enabled    = var.enabled
}

resource "aws_subnet" "private" {
  for_each             = toset(local.private_subnets)
  vpc_id            = var.vpc_id
  availability_zone = var.availability_zone
  cidr_block        = cidrsubnet(var.cidr_block, ceil(log(var.max_subnets, 2)), index(local.private_subnets, each.value))

  tags = merge({
    "Name"      = "${module.private_label.id}${var.delimiter}${each.value}"
    "Stage"     = module.private_label.stage
    "Namespace" = module.private_label.namespace
    "Named"     = each.value
    "Type"      = var.type
  }, var.tags)
}

resource "aws_route_table" "private" {
  for_each  = toset(local.private_subnets)
  vpc_id = var.vpc_id

  tags = {
    "Name"      = "${module.private_label.id}${var.delimiter}${each.value}"
    "Stage"     = module.private_label.stage
    "Namespace" = module.private_label.namespace
  }
}

resource "aws_route" "private" {
  for_each                  = toset(local.private_subnets)
  route_table_id         = aws_route_table.private[each.value].id
  network_interface_id   = var.eni_id
  nat_gateway_id         = var.ngw_id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "private" {
  for_each          = toset(local.private_subnets)
  subnet_id      = aws_subnet.private[each.value].id
  route_table_id = aws_route_table.private[each.value].id
}

resource "aws_network_acl" "private" {
  count      = var.enabled && var.type == "private" && signum(length(var.private_network_acl_id)) == 0 ? 1 : 0
  vpc_id     = data.aws_vpc.default.id
  subnet_ids = values(aws_subnet.private)[*].id

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

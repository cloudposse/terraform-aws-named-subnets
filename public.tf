locals {
  public_count = module.this.enabled && var.type == "public" ? length(var.subnet_names) : 0
  ngw_count    = module.this.enabled && var.type == "public" && var.nat_enabled ? 1 : 0
}

module "public_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  attributes = ["public"]

  context = module.this.context
}

resource "aws_subnet" "public" {
  count                   = local.public_count
  vpc_id                  = var.vpc_id
  availability_zone       = var.availability_zone
  cidr_block              = cidrsubnet(var.cidr_block, ceil(log(var.max_subnets, 2)), count.index)
  map_public_ip_on_launch = var.map_public_ip_on_launch_enabled

  tags = merge(module.public_label.tags, {
    "Name"  = "${module.public_label.id}${module.this.delimiter}${element(var.subnet_names, count.index)}"
    "Named" = var.subnet_names[count.index]
    "Type"  = var.type
  }, var.tags)
}

resource "aws_route_table" "public" {
  count  = local.public_count
  vpc_id = var.vpc_id

  tags = merge(module.public_label.tags, {
    "Name" = "${module.public_label.id}${module.this.delimiter}${element(var.subnet_names, count.index)}"
  })
}

resource "aws_route" "public" {
  count                  = local.public_count
  route_table_id         = aws_route_table.public.*.id[count.index]
  gateway_id             = var.igw_id == "" ? null : var.igw_id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public" {
  count          = local.public_count
  subnet_id      = aws_subnet.public.*.id[count.index]
  route_table_id = aws_route_table.public.*.id[count.index]
}

resource "aws_network_acl" "public" {
  count      = module.this.enabled && var.type == "public" && signum(length(var.public_network_acl_id)) == 0 ? 1 : 0
  vpc_id     = data.aws_vpc.default.id
  subnet_ids = aws_subnet.public.*.id

  dynamic "egress" {
    for_each = var.public_network_acl_egress
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
    for_each = var.public_network_acl_ingress
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
  tags = module.public_label.tags
}

resource "aws_eip" "default" {
  count = local.ngw_count
  vpc   = "true"

  lifecycle {
    create_before_destroy = true
  }

  tags = module.public_label.tags
}

resource "aws_nat_gateway" "default" {
  count         = local.ngw_count
  allocation_id = join("", aws_eip.default.*.id)
  subnet_id     = aws_subnet.public.*.id[0]
  tags          = module.public_label.tags

  lifecycle {
    create_before_destroy = true
  }
}

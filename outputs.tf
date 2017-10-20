output "ngw_ids" {
  value       = ["${aws_nat_gateway.default.*.id}"]
  description = "IDs of NAT Gateways"
}

output "ngw_private_ips" {
  value       = ["${aws_nat_gateway.default.*.private_ip}"]
  description = "The private IP addresses of the NAT Gateways"
}

output "ngw_public_ips" {
  value       = ["${aws_nat_gateway.default.*.public_ip}"]
  description = "The public IP addresses of the NAT Gateways"
}

output "subnet_ids" {
  value       = ["${aws_subnet.default.*.id}"]
  description = "IDs of subnets"
}

module "private_subnets" {
  namespace          = "${var.namespace}"
  stage              = "${var.stage}"
  names              = ["charlie", "echo", "bravo"]
  vpc_id             = "vpc-1234"
  base_cidr          = "10.0.1.0.1/24"
  availability_zones = ["us-east-1a", "us-east-1b"]
  nat_enabled        = "true"
}

module "public_subnets" {
  namespace          = "${var.namespace}"
  stage              = "${var.stage}"
  names              = ["apples", "oranges", "grapes"]
  vpc_id             = "vpc-1234"
  base_cidr          = "10.0.2.0.1/24"
  igw_id             = "ig-1234"
  availability_zones = ["us-east-1a", "us-east-1b"]
}

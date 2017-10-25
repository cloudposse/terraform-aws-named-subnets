output "ngw_id" {
  value       = "${join("", aws_nat_gateway.default.*.id)}"
  description = "IDs of NAT Gateways"
}

output "ngw_private_ip" {
  value       = "${join("", aws_nat_gateway.default.*.private_ip)}"
  description = "The private IP addresses of the NAT Gateways"
}

output "ngw_public_ip" {
  value       = "${join("", aws_nat_gateway.default.*.public_ip)}"
  description = "The public IP addresses of the NAT Gateways"
}

output "subnet_ids" {
  value       = ["${compact(concat(aws_subnet.private.*.id, aws_subnet.public.*.id))}"]
  description = "IDs of private subnets"
}

output "route_table_ids" {
  value = ["${compact(concat(aws_route_table.public.*.id, aws_route_table.private.*.id))}"]
}

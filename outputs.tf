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

output "public_subnet_ids" {
  value = ["${aws_subnet.public.*.id}"]
}

output "private_subnet_ids" {
  value = ["${aws_subnet.private.*.id}"]
}

output "public_route_table_ids" {
  value = ["${aws_route_table.public.*.id}"]
}

output "private_route_table_ids" {
  value = ["${aws_route_table.private.*.id}"]
}

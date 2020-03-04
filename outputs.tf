output "ngw_id" {
  value       = join("", aws_nat_gateway.default.*.id)
  description = "NAT Gateway ID"
}

output "ngw_private_ip" {
  value       = join("", aws_nat_gateway.default.*.private_ip)
  description = "Private IP address of the NAT Gateway"
}

output "ngw_public_ip" {
  value       = join("", aws_nat_gateway.default.*.public_ip)
  description = "Public IP address of the NAT Gateway"
}

output "subnet_ids" {
  description = "Subnet IDs"
  value = coalescelist(
    length(aws_subnet.public) > 0 ? values(aws_subnet.public)[*].id : [],
    length(aws_subnet.private) > 0 ? values(aws_subnet.private)[*].id : []
  )
}

output "route_table_ids" {
  description = "Route table IDs"
  value = coalescelist(
    length(aws_route_table.public) > 0 ? values(aws_route_table.public)[*].id : [],
    length(aws_route_table.private) > 0 ? values(aws_route_table.private)[*].id : []
  )
}

output "named_subnet_ids" {
  description = "Map of subnet names to subnet IDs"

  value = aws_subnet.public
}

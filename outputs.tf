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
  value       = coalescelist(aws_subnet.private.*.id, aws_subnet.public.*.id)
  description = "Subnet IDs"
}

output "route_table_ids" {
  value       = coalescelist(aws_route_table.public.*.id, aws_route_table.private.*.id)
  description = "Route table IDs"
}

output "named_subnet_ids" {
  description = "Map of subnet names to subnet IDs"

  value = zipmap(
    var.subnet_names,
    coalescelist(
      aws_subnet.private.*.id,
      aws_subnet.public.*.id
    )
  )
}

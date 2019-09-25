output "ngw_id" {
  value       = module.subnets.ngw_id
  description = "NAT Gateway ID"
}

output "ngw_private_ip" {
  value       = module.subnets.ngw_private_ip
  description = "Private IP address of the NAT Gateway"
}

output "ngw_public_ip" {
  value       = module.subnets.ngw_public_ip
  description = "Public IP address of the NAT Gateway"
}

output "subnet_ids" {
  value       = module.subnets.subnet_ids
  description = "Subnet IDs"
}

output "route_table_ids" {
  value       = module.subnets.route_table_ids
  description = "Route Table IDs"
}

output "named_subnet_ids" {
  description = "Map of subnet names to subnet IDs"
  value       = module.subnets.named_subnet_ids
}

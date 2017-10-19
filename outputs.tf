output "public_subnet_ids" {
  value       = ["${aws_subnet.public.*.id}"]
  description = "IDs of public subnets"
}

output "private_subnet_ids" {
  value       = ["${aws_subnet.private.*.id}"]
  description = "IDs of private subnets"
}

output "public_route_table_ids" {
  value       = ["${aws_route_table.public.*.id}"]
  description = "IDs of public route tables"
}

output "private_route_table_ids" {
  value       = ["${aws_route_table.private.*.id}"]
  description = "IDs of private route tables"
}

output "vpc_id" {
  value       = "${signum(length(var.vpc_id)) == 1 ? var.vpc_id : module.vpc.vpc_id}"
  description = "ID of VPC"
}

output "igw_id" {
  value       = "${signum(length(var.igw_id)) == 1 ? var.igw_id : module.vpc.igw_id}"
  description = "ID of IGW"
}

output "ngw_id" {
  value       = "${signum(length(var.ngw_id)) == 1 ? var.ngw_id : aws_nat_gateway.default.id}"
  description = "ID of NGW"
}

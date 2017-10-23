variable "namespace" {
  description = "Namespace (e.g. `cp` or `cloudposse`)"
  type        = "string"
}

variable "stage" {
  description = "Stage (e.g. `prod`, `dev`, `staging`)"
  type        = "string"
}

variable "delimiter" {
  type        = "string"
  default     = "-"
  description = "Delimiter to be used between `name`, `namespace`, `stage`, etc."
}

variable "attributes" {
  type        = "list"
  default     = []
  description = "Additional attributes (e.g. `policy` or `role`)"
}

variable "tags" {
  type        = "map"
  default     = {}
  description = "Additional tags (e.g. `map('BusinessUnit`,`XYZ`)"
}

variable "vpc_id" {
  description = "ID of VPC"
}

variable "igw_id" {
  description = "ID of IGW"
  default     = ""
}

variable "cidr_block" {}

variable "public_names" {
  type    = "list"
  default = []
}

variable "private_names" {
  type    = "list"
  default = []
}

variable "public_availability_zone" {}

variable "private_availability_zone" {}

variable "public_network_acl_id" {
  default = ""
}

variable "private_network_acl_id" {
  default = ""
}

variable "vpc_default_route_table_id" {
  default = ""
}

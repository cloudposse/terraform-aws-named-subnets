variable "namespace" {
  description = "Namespace (e.g. `cp` or `cloudposse`)"
  type        = "string"
}

variable "stage" {
  description = "Stage (e.g. `prod`, `dev`, `staging`)"
  type        = "string"
}

variable "name" {
  description = "Name  (e.g. `bastion` or `db`)"
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

variable "availability_zone" {
  default = ""
}

variable "vpc_id" {
  default = ""
}

variable "igw_id" {
  description = "ID of IGW"
  default     = ""
}

variable "ngw_id" {
  description = "ID of NGW"
  default     = ""
}

variable "private_cidr_blocks" {
  description = "List of pirvate CIDR blocks"
  type        = "list"
}

variable "public_cidr_blocks" {
  description = "List of public CIDR blocks"
  type        = "list"
}

variable "additional_private_routes" {
  type    = "map"
  default = {}
}

variable "additional_public_routes" {
  type    = "map"
  default = {}
}

variable "egress" {
  type = "list"

  default = [
    {
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 0
      to_port    = 0
      protocol   = "-1"
    },
  ]
}

variable "ingress" {
  type = "list"

  default = [
    {
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 0
      to_port    = 0
      protocol   = "-1"
    },
  ]
}

variable "private_network_acl_id" {
  default = ""
}

variable "public_network_acl_id" {
  default = ""
}

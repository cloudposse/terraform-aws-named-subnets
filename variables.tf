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

variable "availability_zones" {
  description = "Availability Zones"
  type        = "list"
}

variable "names" {
  type        = "list"
  description = "list of subnets names"
}

variable "vpc_id" {
  description = "ID of VPC"
}

variable "base_cidr" {
  description = "The base CIDR block which will be divided into subnet CIDR blocks (e.g. `10.0.0.0/16`)"
  default     = ""
}

variable "igw_id" {
  description = "ID of IGW"
  default     = ""
}

variable "nat_enabled" {
  default = "false"
}

variable "additional_routes" {
  type    = "map"
  default = {}
}

variable "network_acl_id" {
  description = "Network ACL ID that will be added to the subnets. If empty, a new ACL will be created "
  default     = ""
}

variable "egress" {
  description = " Specifies an egress rules"
  type        = "list"

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
  description = "Specifies an ingress rule"
  type        = "list"

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

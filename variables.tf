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

variable "availability_zone" {
  description = "Availability Zone"
}

variable "public_subnets_names" {
  type        = "list"
  description = "list of subnets names"
  default     = []
}

variable "private_subnets_names" {
  type        = "list"
  description = "list of subnets names"
  default     = []
}

variable "vpc_id" {
  description = "ID of VPC"
}

variable "cidr_block" {
  description = "The base CIDR block which will be divided into subnet CIDR blocks (e.g. `10.0.0.0/16`)"
}

variable "igw_id" {
  description = "ID of IGW"
  default     = ""
}

variable "ngw_id" {
  description = "ID of NGWs"
  default     = ""
}

variable "nat_enabled" {
  default = "false"
}

variable "additional_public_routes" {
  type    = "map"
  default = {}
}

variable "additional_private_routes" {
  type    = "map"
  default = {}
}

variable "public_network_acl_id" {
  description = "Network ACL ID that will be added to the subnets. If empty, a new ACL will be created "
  default     = ""
}

variable "private_network_acl_id" {
  description = "Network ACL ID that will be added to the subnets. If empty, a new ACL will be created "
  default     = ""
}

variable "public_network_acl_egress" {
  description = "Egress network ACL rules"
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

variable "public_network_acl_ingress" {
  description = "Egress network ACL rules"
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

variable "private_network_acl_egress" {
  description = "Egress network ACL rules"
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

variable "private_network_acl_ingress" {
  description = "Egress network ACL rules"
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

variable "names" {
  type = "list"
}

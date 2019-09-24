variable "namespace" {
  description = "Namespace (e.g. `eg` or `cp`)"
  type        = string
  default     = ""
}

variable "stage" {
  description = "Stage (e.g. `prod`, `dev`, `staging`)"
  type        = string
  default     = ""
}

variable "name" {
  type        = string
  description = "Application or solution name"
}

variable "delimiter" {
  type        = string
  default     = "-"
  description = "Delimiter to be used between `name`, `namespace`, `stage`, `attributes`"
}

variable "attributes" {
  type        = list(string)
  default     = []
  description = "Additional attributes (e.g. `policy` or `role`)"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)"
}

variable "subnet_names" {
  type        = list(string)
  description = "List of subnet names (e.g. `['apples', 'oranges', 'grapes']`)"
}

variable "max_subnets" {
  type        = number
  default     = 16
  description = "Maximum number of subnets which can be created. This variable is being used for CIDR blocks calculation. Defaults to length of `subnet_names` argument"
}

variable "type" {
  type        = string
  default     = "private"
  description = "Type of subnets (`private` or `public`)"
}

variable "availability_zone" {
  type        = string
  description = "Availability Zone"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "cidr_block" {
  type        = string
  description = "Base CIDR block which will be divided into subnet CIDR blocks (e.g. `10.0.0.0/16`)"
}

variable "igw_id" {
  type        = string
  description = "Internet Gateway ID which will be used as a default route in public route tables (e.g. `igw-9c26a123`). Conflicts with `ngw_id`"
  default     = ""
}

variable "ngw_id" {
  type        = string
  description = "NAT Gateway ID which will be used as a default route in private route tables (e.g. `igw-9c26a123`). Conflicts with `igw_id`"
  default     = ""
}

variable "public_network_acl_id" {
  type        = string
  description = "Network ACL ID that will be added to the subnets. If empty, a new ACL will be created "
  default     = ""
}

variable "private_network_acl_id" {
  type        = string
  description = "Network ACL ID that will be added to the subnets. If empty, a new ACL will be created "
  default     = ""
}

variable "public_network_acl_egress" {
  description = "Public network egress ACL rules"
  type = list(object(
    {
      rule_no    = number
      action     = string
      cidr_block = string
      from_port  = number
      to_port    = number
      protocol   = string
  }))

  default = [
    {
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 0
      to_port    = 0
      protocol   = "-1"
    }
  ]
}

variable "public_network_acl_ingress" {
  description = "Public network ingress ACL rules"
  type = list(object(
    {
      rule_no    = number
      action     = string
      cidr_block = string
      from_port  = number
      to_port    = number
      protocol   = string
  }))

  default = [
    {
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 0
      to_port    = 0
      protocol   = "-1"
    }
  ]
}

variable "private_network_acl_egress" {
  description = "Private network egress ACL rules"
  type = list(object(
    {
      rule_no    = number
      action     = string
      cidr_block = string
      from_port  = number
      to_port    = number
      protocol   = string
  }))

  default = [
    {
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 0
      to_port    = 0
      protocol   = "-1"
    }
  ]
}

variable "private_network_acl_ingress" {
  description = "Private network ingress ACL rules"
  type = list(object(
    {
      rule_no    = number
      action     = string
      cidr_block = string
      from_port  = number
      to_port    = number
      protocol   = string
  }))

  default = [
    {
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 0
      to_port    = 0
      protocol   = "-1"
    }
  ]
}

variable "enabled" {
  type        = bool
  description = "Set to false to prevent the module from creating any resources"
  default     = true
}

variable "nat_enabled" {
  type        = bool
  description = "Enable/disable NAT Gateway"
  default     = true
}

variable "eni_id" {
  type        = string
  default     = ""
  description = "An ID of a network interface which is used as a default route in private route tables (_e.g._ `eni-9c26a123`)"
}

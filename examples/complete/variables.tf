variable "region" {
  type = string
}

variable "availability_zone" {
  type = string
}

variable "namespace" {
  type = string
}

variable "name" {
  type = string
}

variable "stage" {
  type = string
}

variable "subnet_names" {
  type = list(string)
}

variable "max_subnets" {
  type = number
}

variable "type" {
  type = string
}

variable "nat_enabled" {
  type = bool
}

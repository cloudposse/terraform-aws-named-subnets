variable "region" {
  type = string
}

variable "availability_zone" {
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

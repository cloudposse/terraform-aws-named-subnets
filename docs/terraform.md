## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.12.0 |
| aws | ~> 2.0 |
| null | ~> 2.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 2.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| attributes | Additional attributes (e.g. `policy` or `role`) | `list(string)` | `[]` | no |
| availability\_zone | Availability Zone | `string` | n/a | yes |
| cidr\_block | Base CIDR block which will be divided into subnet CIDR blocks (e.g. `10.0.0.0/16`) | `string` | n/a | yes |
| delimiter | Delimiter to be used between `name`, `namespace`, `stage`, `attributes` | `string` | `"-"` | no |
| enabled | Set to false to prevent the module from creating any resources | `bool` | `true` | no |
| eni\_id | An ID of a network interface which is used as a default route in private route tables (\_e.g.\_ `eni-9c26a123`) | `string` | `""` | no |
| igw\_id | Internet Gateway ID which will be used as a default route in public route tables (e.g. `igw-9c26a123`). Conflicts with `ngw_id` | `string` | `""` | no |
| max\_subnets | Maximum number of subnets which can be created. This variable is being used for CIDR blocks calculation. Defaults to length of `subnet_names` argument | `number` | `16` | no |
| name | Application or solution name | `string` | n/a | yes |
| namespace | Namespace (e.g. `eg` or `cp`) | `string` | `""` | no |
| nat\_enabled | Enable/disable NAT Gateway | `bool` | `true` | no |
| ngw\_id | NAT Gateway ID which will be used as a default route in private route tables (e.g. `igw-9c26a123`). Conflicts with `igw_id` | `string` | `""` | no |
| private\_network\_acl\_egress | Private network egress ACL rules | <pre>list(object(<br>    {<br>      rule_no    = number<br>      action     = string<br>      cidr_block = string<br>      from_port  = number<br>      to_port    = number<br>      protocol   = string<br>  }))</pre> | <pre>[<br>  {<br>    "action": "allow",<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_no": 100,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| private\_network\_acl\_id | Network ACL ID that will be added to the subnets. If empty, a new ACL will be created | `string` | `""` | no |
| private\_network\_acl\_ingress | Private network ingress ACL rules | <pre>list(object(<br>    {<br>      rule_no    = number<br>      action     = string<br>      cidr_block = string<br>      from_port  = number<br>      to_port    = number<br>      protocol   = string<br>  }))</pre> | <pre>[<br>  {<br>    "action": "allow",<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_no": 100,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| public\_network\_acl\_egress | Public network egress ACL rules | <pre>list(object(<br>    {<br>      rule_no    = number<br>      action     = string<br>      cidr_block = string<br>      from_port  = number<br>      to_port    = number<br>      protocol   = string<br>  }))</pre> | <pre>[<br>  {<br>    "action": "allow",<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_no": 100,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| public\_network\_acl\_id | Network ACL ID that will be added to the subnets. If empty, a new ACL will be created | `string` | `""` | no |
| public\_network\_acl\_ingress | Public network ingress ACL rules | <pre>list(object(<br>    {<br>      rule_no    = number<br>      action     = string<br>      cidr_block = string<br>      from_port  = number<br>      to_port    = number<br>      protocol   = string<br>  }))</pre> | <pre>[<br>  {<br>    "action": "allow",<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_no": 100,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| stage | Stage (e.g. `prod`, `dev`, `staging`) | `string` | `""` | no |
| subnet\_names | List of subnet names (e.g. `['apples', 'oranges', 'grapes']`) | `list(string)` | n/a | yes |
| tags | Additional tags (e.g. map(`BusinessUnit`,`XYZ`) | `map(string)` | `{}` | no |
| type | Type of subnets (`private` or `public`) | `string` | `"private"` | no |
| vpc\_id | VPC ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| named\_subnet\_ids | Map of subnet names to subnet IDs |
| ngw\_id | NAT Gateway ID |
| ngw\_private\_ip | Private IP address of the NAT Gateway |
| ngw\_public\_ip | Public IP address of the NAT Gateway |
| route\_table\_ids | Route table IDs |
| subnet\_ids | Subnet IDs |


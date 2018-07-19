
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| attributes | Additional attributes (e.g. `policy` or `role`) | list | `<list>` | no |
| availability_zone | Availability Zone | string | - | yes |
| cidr_block | Base CIDR block which will be divided into subnet CIDR blocks (e.g. `10.0.0.0/16`) | string | - | yes |
| delimiter | Delimiter to be used between `name`, `namespace`, `stage`, `attributes` | string | `-` | no |
| enabled | Set to false to prevent the module from creating any resources | string | `true` | no |
| eni_id | An ID of a network interface which is used as a default route in private route tables (_e.g._ `eni-9c26a123`) | string | `` | no |
| igw_id | Internet Gateway ID which will be used as a default route in public route tables (e.g. `igw-9c26a123`). Conflicts with `ngw_id` | string | `` | no |
| max_subnets | Maximum number of subnets which can be created. This variable is being used for CIDR blocks calculation. Default to length of `names` argument | string | `16` | no |
| name | Application or solution name | string | - | yes |
| namespace | Namespace (e.g. `cp` or `cloudposse`) | string | - | yes |
| nat_enabled | Flag of creation NAT Gateway | string | `true` | no |
| ngw_id | NAT Gateway ID which will be used as a default route in private route tables (e.g. `igw-9c26a123`). Conflicts with `igw_id` | string | `` | no |
| private_network_acl_egress | Egress network ACL rules | list | `<list>` | no |
| private_network_acl_id | Network ACL ID that will be added to the subnets. If empty, a new ACL will be created | string | `` | no |
| private_network_acl_ingress | Egress network ACL rules | list | `<list>` | no |
| public_network_acl_egress | Egress network ACL rules | list | `<list>` | no |
| public_network_acl_id | Network ACL ID that will be added to the subnets. If empty, a new ACL will be created | string | `` | no |
| public_network_acl_ingress | Egress network ACL rules | list | `<list>` | no |
| stage | Stage (e.g. `prod`, `dev`, `staging`) | string | - | yes |
| subnet_names | List of subnet names (e.g. `['apples', 'oranges', 'grapes']`) | list | - | yes |
| tags | Additional tags (e.g. map(`BusinessUnit`,`XYZ`) | map | `<map>` | no |
| type | Type of subnets (`private` or `public`) | string | `private` | no |
| vpc_id | VPC ID | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| named_subnet_ids | Map of subnet names to subnet IDs |
| ngw_id | NAT Gateway ID |
| ngw_private_ip | Private IP address of the NAT Gateway |
| ngw_public_ip | Public IP address of the NAT Gateway |
| route_table_ids | Route Table IDs |
| subnet_ids | Subnet IDs |


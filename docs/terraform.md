<!-- markdownlint-disable -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.0 |
| aws | >= 2.0 |
| null | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| private_label | cloudposse/label/null | 0.24.1 |
| public_label | cloudposse/label/null | 0.24.1 |
| this | cloudposse/label/null | 0.24.1 |

## Resources

| Name |
|------|
| [aws_eip](https://registry.terraform.io/providers/hashicorp/aws/2.0/docs/resources/eip) |
| [aws_nat_gateway](https://registry.terraform.io/providers/hashicorp/aws/2.0/docs/resources/nat_gateway) |
| [aws_network_acl](https://registry.terraform.io/providers/hashicorp/aws/2.0/docs/resources/network_acl) |
| [aws_route](https://registry.terraform.io/providers/hashicorp/aws/2.0/docs/resources/route) |
| [aws_route_table](https://registry.terraform.io/providers/hashicorp/aws/2.0/docs/resources/route_table) |
| [aws_route_table_association](https://registry.terraform.io/providers/hashicorp/aws/2.0/docs/resources/route_table_association) |
| [aws_subnet](https://registry.terraform.io/providers/hashicorp/aws/2.0/docs/resources/subnet) |
| [aws_vpc](https://registry.terraform.io/providers/hashicorp/aws/2.0/docs/data-sources/vpc) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_tag\_map | Additional tags for appending to tags\_as\_list\_of\_maps. Not added to `tags`. | `map(string)` | `{}` | no |
| attributes | Additional attributes (e.g. `1`) | `list(string)` | `[]` | no |
| availability\_zone | Availability Zone | `string` | n/a | yes |
| cidr\_block | Base CIDR block which will be divided into subnet CIDR blocks (e.g. `10.0.0.0/16`) | `string` | n/a | yes |
| context | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | `any` | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_key_case": null,<br>  "label_order": [],<br>  "label_value_case": null,<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {}<br>}</pre> | no |
| delimiter | Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes`.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| enabled | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| eni\_id | An ID of a network interface which is used as a default route in private route tables (\_e.g.\_ `eni-9c26a123`) | `string` | `""` | no |
| environment | Environment, e.g. 'uw2', 'us-west-2', OR 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| id\_length\_limit | Limit `id` to this many characters (minimum 6).<br>Set to `0` for unlimited length.<br>Set to `null` for default, which is `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| igw\_id | Internet Gateway ID which will be used as a default route in public route tables (e.g. `igw-9c26a123`). Conflicts with `ngw_id` | `string` | `""` | no |
| label\_key\_case | The letter case of label keys (`tag` names) (i.e. `name`, `namespace`, `environment`, `stage`, `attributes`) to use in `tags`.<br>Possible values: `lower`, `title`, `upper`.<br>Default value: `title`. | `string` | `null` | no |
| label\_order | The naming order of the id output and Name tag.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 5 elements, but at least one must be present. | `list(string)` | `null` | no |
| label\_value\_case | The letter case of output label values (also used in `tags` and `id`).<br>Possible values: `lower`, `title`, `upper` and `none` (no transformation).<br>Default value: `lower`. | `string` | `null` | no |
| map\_public\_ip\_on\_launch\_enabled | Enable/disable map\_public\_ip\_on\_launch subnet attribute. | `bool` | `false` | no |
| max\_subnets | Maximum number of subnets which can be created. This variable is being used for CIDR blocks calculation. Defaults to length of `subnet_names` argument | `number` | `16` | no |
| name | Solution name, e.g. 'app' or 'jenkins' | `string` | `null` | no |
| namespace | Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp' | `string` | `null` | no |
| nat\_enabled | Enable/disable NAT Gateway | `bool` | `true` | no |
| ngw\_id | NAT Gateway ID which will be used as a default route in private route tables (e.g. `igw-9c26a123`). Conflicts with `igw_id` | `string` | `""` | no |
| private\_network\_acl\_egress | Private network egress ACL rules | <pre>list(object(<br>    {<br>      rule_no    = number<br>      action     = string<br>      cidr_block = string<br>      from_port  = number<br>      to_port    = number<br>      protocol   = string<br>  }))</pre> | <pre>[<br>  {<br>    "action": "allow",<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_no": 100,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| private\_network\_acl\_id | Network ACL ID that will be added to the subnets. If empty, a new ACL will be created | `string` | `""` | no |
| private\_network\_acl\_ingress | Private network ingress ACL rules | <pre>list(object(<br>    {<br>      rule_no    = number<br>      action     = string<br>      cidr_block = string<br>      from_port  = number<br>      to_port    = number<br>      protocol   = string<br>  }))</pre> | <pre>[<br>  {<br>    "action": "allow",<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_no": 100,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| public\_network\_acl\_egress | Public network egress ACL rules | <pre>list(object(<br>    {<br>      rule_no    = number<br>      action     = string<br>      cidr_block = string<br>      from_port  = number<br>      to_port    = number<br>      protocol   = string<br>  }))</pre> | <pre>[<br>  {<br>    "action": "allow",<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_no": 100,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| public\_network\_acl\_id | Network ACL ID that will be added to the subnets. If empty, a new ACL will be created | `string` | `""` | no |
| public\_network\_acl\_ingress | Public network ingress ACL rules | <pre>list(object(<br>    {<br>      rule_no    = number<br>      action     = string<br>      cidr_block = string<br>      from_port  = number<br>      to_port    = number<br>      protocol   = string<br>  }))</pre> | <pre>[<br>  {<br>    "action": "allow",<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_no": 100,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| regex\_replace\_chars | Regex to replace chars with empty string in `namespace`, `environment`, `stage` and `name`.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| stage | Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| subnet\_names | List of subnet names (e.g. `['apples', 'oranges', 'grapes']`) | `list(string)` | n/a | yes |
| tags | Additional tags (e.g. `map('BusinessUnit','XYZ')` | `map(string)` | `{}` | no |
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
<!-- markdownlint-restore -->

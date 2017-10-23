# terraform-aws-named-subnets

Terraform module for named `subnets` provisioning.


## Usage

```terraform
module "named_subnets" {
  source                    = "git::https://github.com/cloudposse/terraform-aws-named-subnets.git?ref=master"
  namespace                 = "${var.namespace}"
  stage                     = "${var.stage}"
  public_names              = ["${var.public_names}"]
  private_names             = ["${var.private_names}"]
  public_availability_zone  = "${var.public_availability_zone}"
  private_availability_zone = "${var.private_availability_zone}"
  vpc_id                    = "${var.vpc_id}"
  cidr_block                = "${var.cidr_block}"
  igw_id                    = "${var.igw_id}"
}
```

# Inputs

| Name                          | Default | Description                                                                                                                             | Required |
|:------------------------------|:-------:|:----------------------------------------------------------------------------------------------------------------------------------------|:--------:|
| `namespace`                   |   ``    | Namespace (e.g. `cp` or `cloudposse`)                                                                                                   |   Yes    |
| `stage`                       |   ``    | Stage (e.g. `prod`, `dev`, `staging`)                                                                                                   |   Yes    |
| `delimiter`                   |   ``    | Delimiter to be used between `name`, `namespace`, `stage`, etc.                                                                         |    No    |
| `attributes`                  |  `[]`   | Additional attributes (e.g. `policy` or `role`)                                                                                         |    No    |
| `tags`                        |  `{}`   | Additional tags  (e.g. `map("BusinessUnit","XYZ")`                                                                                      |    No    |
| `vpc_id`                      |   ``    | The VPC ID where subnets will be created (e.g. `vpc-aceb2723`). If empty, a new VPC will be created                                     |   Yes    |
| `igw_id`                      |   ``    | The Internet Gateway ID public route table will point to (e.g. `igw-9c26a123`). Conflicts with `nat_enabled = true`                     |    No    |
| `cidr_block`                  |   ``    | The base CIDR block which will be divided into subnet CIDR blocks (e.g. `10.0.0.0/16`)                                                  |   Yes    |
| `public_names`                |   ``    | List of names for public subnets (e.g. "charlie", "echo", "bravo")                                                                      |   Yes    |
| `private_names`               |   ``    | List of names for private subnets (e.g. "apple", "orange", "grapes")                                                                    |   Yes    |
| `public_availability_zone`    |   ``    | An availability zone, where public subnets will be created (e.g. "us-east-1a")                                                          |   Yes    |
| `private_availability_zone`   |   ``    | An availability zone, where private subnets will be created (e.g. "us-east-1a")                                                         |   Yes    |
| `public_network_acl_id`       |   ``    | Network ACL ID that will be used with public subnets.  If empty (or not specified), a new ACL will be created                           |    No    |
| `private_network_acl_id`      |   ``    | Network ACL ID that will be used with private subnets.  If empty (or not specified), a new ACL will be created                          |    No    |
| `vpc_default_route_table_id`  |   ``    | The default route table for public subnets. Provides access to the Internet. If not set here, will be created. (e.g. `rtb-f4f0ce12`)    |    No    |


## Outputs

| Name                      | Description                                           |
|:--------------------------|:------------------------------------------------------|
| ngw_ids                   | IDs of NAT Gateways                                   |
| ngw_private_ips           | The private IP addresses of the NAT Gateways          |
| ngw_public_ips            | The public IP addresses of the NAT Gateways           |
| subnet_ids                | IDs of subnets                                        |
| public_subnet_ids         | IDs of public subnets                                 |
| private_subnet_ids        | IDs of private subnets                                |
| public_route_table_ids    | IDs of route tables, associated with public subnets   |
| private_route_table_ids   | IDs of route tables, associated with private subnets  |

## License

Apache 2 License. See [`LICENSE`](LICENSE) for full details.

# terraform-aws-named-subnets

Terraform module for named `subnets` provisioning.


## Usage

Simple example:

Full example:

```terraform
module "vpc" {
  source = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref=remove_subnets"
  namespace          = "cp"
  name               = "vpc1"
  stage              = "test"
  cidr_block         = "${var.cidr_block}"
}

locals {
  us_east_1a_public_cidr_block  = "${cidrsubnet(module.vpc.cidr_block, 2, 0)}"
  us_east_1a_private_cidr_block = "${cidrsubnet(module.vpc.cidr_block, 2, 1)}"
  us_east_1b_public_cidr_block  = "${cidrsubnet(module.vpc.cidr_block, 2, 2)}"
  us_east_1b_private_cidr_block = "${cidrsubnet(module.vpc.cidr_block, 2, 3)}"

}

module "us_east_1a_public_subnet" {
  source             = "git::https://github.com/cloudposse/terraform-aws-named-subnets.git?ref=master"
  name               = "public"
  attributes         = ["us-east-1a"]
  namespace          = "${var.namespace}"
  stage              = "${var.stage}"
  names              = ["apples", "oranges", "grapes"]
  vpc_id             = "${module.vpc.vpc_id}"
  base_cidr          = "${local.us_east_1a_public_cidr_block}"
  igw_id             = "${module.vpc.igw_id}"
  availability_zone  = "us-east-1a"
}

module "us_east_1a_private_subnet" {
  source             = "git::https://github.com/cloudposse/terraform-aws-named-subnets.git?ref=master"
  name               = "private"
  attributes         = ["us-east-1a"]
  namespace          = "${var.namespace}"
  stage              = "${var.stage}"
  names              = ["charlie", "echo", "bravo"]
  vpc_id             = "${module.vpc.vpc_id}"
  cidr_block         = "${local.us_east_1a_private_cidr_block}"
  availability_zone  = "us-east-1a"
  ngw_id             = "${module.us_east_1a_public_subnet.ngw_id}"
}

module "us_east_1b_public_subnets" {
  source             = "git::https://github.com/cloudposse/terraform-aws-named-subnets.git?ref=master"
  name               = "public"
  attributes         = ["us-east-1b"]
  namespace          = "${var.namespace}"
  stage              = "${var.stage}"
  names              = ["apples", "oranges", "grapes"]
  vpc_id             = "${module.vpc.vpc_id}"
  base_cidr          = "${local.us_east_1b_public_cidr_block}"
  igw_id             = "${module.vpc.igw_id}"
  availability_zone  = "us-east-1b"
}

module "us_east_1b_private_subnets" {
  source             = "git::https://github.com/cloudposse/terraform-aws-named-subnets.git?ref=master"
  name               = "private"
  attributes         = ["us-east-1b"]
  namespace          = "${var.namespace}"
  stage              = "${var.stage}"
  names              = ["charlie", "echo", "bravo"]
  vpc_id             = "${module.vpc.vpc_id}"
  cidr_block         = "${local.us_east_1b_private_cidr_block}"
  availability_zone  = "us-east-1b"
  ngw_id             = "${module.us_east_1b_public_subnets.ngw_id}"
}
```

# Inputs

| Name                  | Default | Description                                                                                                         | Required |
|:----------------------|:-------:|:--------------------------------------------------------------------------------------------------------------------|:--------:|
| `namespace`           |   ``    | Namespace (e.g. `cp` or `cloudposse`)                                                                               |   Yes    |
| `stage`               |   ``    | Stage (e.g. `prod`, `dev`, `staging`)                                                                               |   Yes    |
| `name`                |   ``    | Name  (e.g. `bastion` or `db`)                                                                                      |   Yes    |
| `attributes`          |  `[]`   | Additional attributes (e.g. `policy` or `role`)                                                                     |    No    |
| `tags`                |  `{}`   | Additional tags  (e.g. `map("BusinessUnit","XYZ")`                                                                  |    No    |
| `names`               |   ``    | List of subnets names (e.g. `["apples", "oranges", "grapes"]`)                                                      |   Yes    |
| `vpc_id`              |   ``    | The VPC ID where subnets will be created (e.g. `vpc-aceb2723`). If empty, a new VPC will be created                 |   Yes    |
| `base_cidr`           |   ``    | The base CIDR block which will be divided into subnet CIDR blocks (e.g. `10.0.0.0/16`)                              |    No    |
| `igw_id`              |   ``    | The Internet Gateway ID public route table will point to (e.g. `igw-9c26a123`). Conflicts with `nat_enabled = true` |    No    |
| `nat_enabled`         | `false` | Flag to enable/disable NAT gateways. Conflicts with non-empty `igw_id`                                              |    No    |
| `availability_zones`  |   ``    | The  list of Availability Zones where subnets will be created (e.g. `["us-east-1a", "us-east-1b"]`).                |   Yes    |
| `network_acl_id`      |   ``    | Network ACL ID that will be added to the subnets.  If empty, a new ACL will be created                              |    No    |
| `additional_routes`   |  `{}`   | Map of Additional routes for subnets (e.g. `{"10.0.0.2/24" = igw-0038f979}`)                                        |    No    |
| `network_acl_egress`  |  `[]`   | List of Network ACL CIDRs permitted egress                                                                          |    No    |
| `network_acl_ingress` |  `[]`   | List of Network ACL CIDRs permitted ingress                                                                         |    No    |

## Outputs

| Name            | Description                                  |
|:----------------|:---------------------------------------------|
| ngw_ids         | IDs of NAT Gateways                          |
| ngw_private_ips | The private IP addresses of the NAT Gateways |
| ngw_public_ips  | The public IP addresses of the NAT Gateways  |
| subnet_ids      | IDs of subnets                               |

## License

Apache 2 License. See [`LICENSE`](LICENSE) for full details.

# terraform-aws-named-subnets

Terraform module for named `subnets` provisioning.


## Usage

Simple example:

Full example:

```terraform
module "vpc" {
  source     = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref=remove_subnets"
  namespace  = "${var.namespace}"
  name       = "vpc"
  stage      = "${var.stage}"
  cidr_block = "${var.cidr_block}"
}

locals {
  us_east_1a_public_cidr_block  = "${cidrsubnet(module.vpc.vpc_cidr_block, 2, 0)}"
  us_east_1a_private_cidr_block = "${cidrsubnet(module.vpc.vpc_cidr_block, 2, 1)}"
  us_east_1b_public_cidr_block  = "${cidrsubnet(module.vpc.vpc_cidr_block, 2, 2)}"
  us_east_1b_private_cidr_block = "${cidrsubnet(module.vpc.vpc_cidr_block, 2, 3)}"
}

module "us_east_1a_public_subnets" {
  source            = "git::https://github.com/cloudposse/terraform-aws-named-subnets.git?ref=master"
  namespace         = "${var.namespace}"
  stage             = "${var.stage}"
  names             = ["apples", "oranges", "grapes"]
  vpc_id            = "${module.vpc.vpc_id}"
  cidr_block        = "${local.us_east_1a_public_cidr_block}"
  type              = "public"
  igw_id            = "${module.vpc.igw_id}"
  availability_zone = "us-east-1a"
}

module "us_east_1a_private_subnets" {
  source            = "git::https://github.com/cloudposse/terraform-aws-named-subnets.git?ref=master"
  attributes        = ["us-east-1a"]
  namespace         = "${var.namespace}"
  stage             = "${var.stage}"
  names             = ["charlie", "echo", "bravo"]
  vpc_id            = "${module.vpc.vpc_id}"
  cidr_block        = "${local.us_east_1a_private_cidr_block}"
  type              = "private"
  availability_zone = "us-east-1a"
  ngw_id            = "${module.us_east_1a_public_subnets.ngw_id}"
}

module "us_east_1b_public_subnets" {
  source            = "git::https://github.com/cloudposse/terraform-aws-named-subnets.git?ref=master"
  attributes        = ["us-east-1b"]
  namespace         = "${var.namespace}"
  stage             = "${var.stage}"
  names             = ["apples", "oranges", "grapes"]
  vpc_id            = "${module.vpc.vpc_id}"
  cidr_block        = "${local.us_east_1b_public_cidr_block}"
  type              = "public"
  igw_id            = "${module.vpc.igw_id}"
  availability_zone = "us-east-1b"
}

module "us_east_1b_private_subnets" {
  source            = "git::https://github.com/cloudposse/terraform-aws-named-subnets.git?ref=master"
  attributes        = ["us-east-1b"]
  namespace         = "${var.namespace}"
  stage             = "${var.stage}"
  names             = ["charlie", "echo", "bravo"]
  vpc_id            = "${module.vpc.vpc_id}"
  cidr_block        = "${local.us_east_1b_private_cidr_block}"
  type              = "private"
  availability_zone = "us-east-1b"
  ngw_id            = "${module.us_east_1b_public_subnets.ngw_id}"
}
```

# Inputs

| Name                          | Default               | Description                                                                                                                           | Required |
|:------------------------------|:---------------------:|:--------------------------------------------------------------------------------------------------------------------------------------|:--------:|
| `namespace`                   | ``                    | Namespace (e.g. `cp` or `cloudposse`)                                                                                                 |   Yes    |
| `stage`                       | ``                    | Stage (e.g. `prod`, `dev`, `staging`)                                                                                                 |   Yes    |
| `delimiter`                   | `-`                   | Delimiter to be used between `name`, `namespace`, `stage`, etc.                                                                       |    No    |
| `attributes`                  | `[]`                  | Additional attributes (e.g. `policy` or `role`)                                                                                       |    No    |
| `tags`                        | `{}`                  | Additional tags  (e.g. `map("BusinessUnit","XYZ")`                                                                                    |    No    |
| `names`                       | ``                    | List of subnets names (e.g. `["apples", "oranges", "grapes"]`)                                                                        |   Yes    |
| `availability_zone`           | ``                    | An Availability Zone where subnets will be created (e.g. `us-east-1a`).                                                               |   Yes    |
| `type`                        | `private`             | A type of subnets (e.g. `private`, or `public`)                                                                                       |    No    |
| `vpc_id`                      | ``                    | A VPC ID where subnets will be created (e.g. `vpc-aceb2723`). If empty, a new VPC will be created                                     |   Yes    |
| `cidr_block`                  | ``                    | A base CIDR block which will be divided into subnet CIDR blocks (e.g. `10.0.0.0/24`)                                                  |    No    |
| `igw_id`                      | ``                    | An Internet Gateway ID which will be used as a default route in public route tables (e.g. `igw-9c26a123`). Conflicts with `ngw_id`    |   Yes    |
| `ngw_id`                      | ``                    | A NAT Gateway ID which will be used as a default route in private route tables (e.g. `igw-9c26a123`). Conflicts with `igw_id`         |   Yes    |
| `public_network_acl_id`       | ``                    | ID of Network ACL which will be added to the public subnets.  If empty, a new ACL will be created                                     |    No    |
| `private_network_acl_id`      | ``                    | ID of Network ACL which will be added to the private subnets.  If empty, a new ACL will be created                                    |    No    |
| `public_network_acl_egress`   | see [variables.tf]    | An Egress ACL which will be added to the new Public Network ACL                                                                       |    No    |
| `public_network_acl_ingress`  | see [variables.tf]    | An Ingress ACL which will be added to the new Public Network ACL                                                                      |    No    |
| `private_network_acl_egress`  | see [variables.tf]    | An Egress ACL which will be added to the new Private Network ACL                                                                      |    No    |
| `private_network_acl_ingress` | see [variables.tf]    | An Ingress ACL which will be added to the new Private Network ACL                                                                     |    No    |


## Outputs

| Name            | Description                                  |
|:----------------|:---------------------------------------------|
| ngw_id          | ID of NAT Gateway                            |
| ngw_private_ip  | A private IP address of a NAT Gateway        |
| ngw_public_ip   | A public IP address of a NAT Gateway         |
| subnet_ids      | IDs of Subnets                               |
| route_table_ids | IDs of Route Tables                          |

## License

Apache 2 License. See [`LICENSE`](LICENSE) for full details.

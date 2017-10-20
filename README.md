# terraform-aws-named-subnets

Terraform module for named `subnets` provisioning.


## Usage

```terraform
module "private_subnets" {
  namespace          = "${var.namespace}"
  stage              = "${var.stage}"
  names              = ["charlie", "echo", "bravo"]
  vpc_id             = "vpc-1234"
  base_cidr          = "10.0.1.0.1/24"
  availability_zones = ["us-east-1a", "us-east-1b"]
  nat_enabled        = "true"
}

module "public_subnets" {
  namespace          = "${var.namespace}"
  stage              = "${var.stage}"
  names              = ["apples", "oranges", "grapes"]
  vpc_id             = "vpc-1234"
  base_cidr          = "10.0.2.0.1/24"
  igw_id             = "ig-1234"
  availability_zones = ["us-east-1a", "us-east-1b"]
}
```

# Inputs

| Name                 | Default | Description                                                                                                         | Required |
|:---------------------|:-------:|:--------------------------------------------------------------------------------------------------------------------|:--------:|
| `namespace`          |   ``    | Namespace (e.g. `cp` or `cloudposse`)                                                                               |   Yes    |
| `stage`              |   ``    | Stage (e.g. `prod`, `dev`, `staging`)                                                                               |   Yes    |
| `name`               |   ``    | Name  (e.g. `bastion` or `db`)                                                                                      |   Yes    |
| `attributes`         |  `[]`   | Additional attributes (e.g. `policy` or `role`)                                                                     |    No    |
| `tags`               |  `{}`   | Additional tags  (e.g. `map("BusinessUnit","XYZ")`                                                                  |    No    |
| `names`              |   ``    | List of subnets names (e.g. `["apples", "oranges", "grapes"]`)                                                      |   Yes    |
| `vpc_id`             |   ``    | The VPC ID where subnets will be created (e.g. `vpc-aceb2723`). If empty, a new VPC will be created                 |   Yes    |
| `base_cidr`          |   ``    | The base CIDR block which will be divided into subnet CIDR blocks (e.g. `10.0.0.0/16`)                              |    No    |
| `igw_id`             |   ``    | The Internet Gateway ID public route table will point to (e.g. `igw-9c26a123`). Conflicts with `nat_enabled = true` |    No    |
| `nat_enabled`        | `false` | Flag to enable/disable NAT gateways. Conflicts with non-empty `igw_id`                                              |    No    |
| `availability_zones` |   ``    | The  list of Availability Zones where subnets will be created (e.g. `["us-east-1a", "us-east-1b"]`).                |   Yes    |
| `network_acl_id`     |   ``    | Network ACL ID that will be added to the subnets.  If empty, a new ACL will be created                              |    No    |
| `additional_routes`  |  `{}`   | Map of Additional routes for subnets (e.g. `{"10.0.0.2/24" = igw-0038f979}`)                                        |    No    |
| `egress`             |  `[]`   | Specifies an egress rules                                                                                           |    No    |
| `ingress`            |  `[]`   | Specifies an ingress rule                                                                                           |    No    |

## Outputs

| Name            | Description                                  |
|:----------------|:---------------------------------------------|
| ngw_ids         | IDs of NAT Gateways                          |
| ngw_private_ips | The private IP addresses of the NAT Gateways |
| ngw_public_ips  | The public IP addresses of the NAT Gateways  |
| subnet_ids      | IDs of subnets                               |

## License

Apache 2 License. See [`LICENSE`](LICENSE) for full details.

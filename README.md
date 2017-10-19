# terraform-aws-named-subnets

Terraform module for public and private `subnets` provisioning.


## Usage

```terraform
module "subnets" {
  namespace          = "${var.namespace}"
  name               = "${var.name}"
  stage              = "${var.stage}"
  public_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
  public_cidr_blocks = ["10.0.3.0/24", "10.0.4.0/24"]
}
```

# Inputs

| Name                        |    Default    | Description                                                                                                                   | Required |
|:----------------------------|:-------------:|:------------------------------------------------------------------------------------------------------------------------------|:--------:|
| `namespace`                 |      ``       | Namespace (e.g. `cp` or `cloudposse`)                                                                                         |   Yes    |
| `stage`                     |      ``       | Stage (e.g. `prod`, `dev`, `staging`)                                                                                         |   Yes    |
| `name`                      |      ``       | Name  (e.g. `bastion` or `db`)                                                                                                |   Yes    |
| `attributes`                |     `[]`      | Additional attributes (e.g. `policy` or `role`)                                                                               |    No    |
| `tags`                      |     `{}`      | Additional tags  (e.g. `map("BusinessUnit","XYZ")`                                                                            |    No    |
| `vpc_id`                    |      ``       | The VPC ID where subnets will be created (e.g. `vpc-aceb2723`). If empty, a new VPC will be created                           |    No    |
| `cidr_block`                | `10.0.0.0/16` | The base CIDR block which will be divided into subnet CIDR blocks (e.g. `10.0.0.0/16`)                                        |    No    |
| `igw_id`                    |      ``       | The Internet Gateway ID public route table will point to (e.g. `igw-9c26a123`)                                                |    No    |
| `ngw_id`                    |      ``       | ID of NGW. If empty, a new NGW will be created                                                                                |    No    |
| `availability_zones`        |      ``       | The Availability Zones where subnets will be created (e.g. `us-eas-1a`). if empty will be used the first AZ in current region |    No    |
| `public_network_acl_id`     |      ``       | Network ACL ID that will be added to public subnets.  If empty, a new ACL will be created                                     |    No    |
| `private_network_acl_id`    |      ``       | Network ACL ID that will be added to private subnets.  If empty, a new ACL will be created                                    |    No    |
| `additional_private_routes` |     `{}`      | Map of Additional routes for private subnet (e.g. `{"10.0.0.2/24" = igw-0038f979}`)                                           |    No    |
| `additional_public_routes`  |     `{}`      | Map of Additional routes for public subnet (e.g. `{"10.0.0.4/24" = igw-0038f970 }`                                            |    No    |
| `egress`                    |     `[]`      | Specifies an egress rules                                                                                                     |    No    |
| `ingress`                   |     `[]`      | Specifies an ingress rule                                                                                                     |    No    |
| `public_cidr_blocks`        |     `[]`      | List of public CIDR blocks                                                                                                    |   Yes    |
| `private_cidr_blocks`       |     `[]`      | List of private CIDR blocks                                                                                                   |   Yes    |

## Outputs

| Name                    | Description                 |
|:------------------------|:----------------------------|
| igw_id                  | ID of IGW                   |
| ngw_id                  | ID of NGW                   |
| private_route_table_ids | IDs of private route tables |
| private_subnet_ids      | IDs of private subnets      |
| public_route_table_ids  | IDs of public route tables  |
| public_subnet_ids       | IDs of public subnets       |
| vpc_id                  | ID of VPC                   |

## License

Apache 2 License. See [`LICENSE`](LICENSE) for full details.

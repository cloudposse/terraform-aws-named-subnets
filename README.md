<!-- This file was automatically generated by the `build-harness`. Make all changes to `README.yaml` and run `make readme` to rebuild this file. -->

[![Cloud Posse](https://cloudposse.com/logo-300x69.svg)](https://cloudposse.com)

# terraform-aws-named-subnets [![Build Status](https://travis-ci.org/cloudposse/terraform-aws-named-subnets.svg?branch=master)](https://travis-ci.org/cloudposse/terraform-aws-named-subnets) [![Latest Release](https://img.shields.io/github/release/cloudposse/terraform-aws-named-subnets.svg)](https://github.com/cloudposse/terraform-aws-named-subnets/releases/latest) [![Slack Community](https://slack.cloudposse.com/badge.svg)](https://slack.cloudposse.com)


Terraform module for named [`subnets`](http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_Subnets.html) provisioning.


---

This project is part of our comprehensive ["SweetOps"](https://docs.cloudposse.com) approach towards DevOps. 


It's 100% Open Source and licensed under the [APACHE2](LICENSE).














## Examples

Simple example, with private and public subnets in one Availability Zone:

```terraform
module "vpc" {
  source     = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref=master"
  namespace  = "${var.namespace}"
  name       = "vpc"
  stage      = "${var.stage}"
  cidr_block = "${var.cidr_block}"
}

locals {
  public_cidr_block  = "${cidrsubnet(module.vpc.vpc_cidr_block, 1, 0)}"
  private_cidr_block = "${cidrsubnet(module.vpc.vpc_cidr_block, 1, 1)}"
}

module "public_subnets" {
  source            = "git::https://github.com/cloudposse/terraform-aws-named-subnets.git?ref=master"
  namespace         = "${var.namespace}"
  stage             = "${var.stage}"
  name              = "${var.name}"
  subnet_names      = ["web1", "web2", "web3"]
  vpc_id            = "${module.vpc.vpc_id}"
  cidr_block        = "${local.public_cidr_block}"
  type              = "public"
  igw_id            = "${module.vpc.igw_id}"
  availability_zone = "us-east-1a"
}

module "private_subnets" {
  source            = "git::https://github.com/cloudposse/terraform-aws-named-subnets.git?ref=master"
  namespace         = "${var.namespace}"
  stage             = "${var.stage}"
  name              = "${var.name}"
  subnet_names      = ["kafka", "cassandra", "zookeeper"]
  vpc_id            = "${module.vpc.vpc_id}"
  cidr_block        = "${local.private_cidr_block}"
  type              = "private"
  availability_zone = "us-east-1a"
  ngw_id            = "${module.public_subnets.ngw_id}"
}
```

Simple example, with `ENI` as default route gateway for private subnets

```terraform
resource "aws_network_interface" "default" {
  subnet_id         = "${module.us_east_1b_public_subnets.subnet_ids[0]}"
  source_dest_check = "false"
  tags              = "${module.network_interface_label.id}
}

module "us_east_1b_private_subnets" {
  source            = "git::https://github.com/cloudposse/terraform-aws-named-subnets.git?ref=master"
  namespace         = "${var.namespace}"
  stage             = "${var.stage}"
  name              = "${var.name}"
  subnet_names      = ["charlie", "echo", "bravo"]
  vpc_id            = "${module.vpc.vpc_id}"
  cidr_block        = "${local.us_east_1b_private_cidr_block}"
  type              = "private"
  availability_zone = "us-east-1b"
  eni_id            = "${aws_network_interface.default.id}"
  attributes        = ["us-east-1b"]
}
```

Full example, with private and public subnets in two Availability Zones for High Availability:

```terraform
module "vpc" {
  source     = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref=master"
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
  name              = "${var.name}"
  subnet_names      = ["apples", "oranges", "grapes"]
  vpc_id            = "${module.vpc.vpc_id}"
  cidr_block        = "${local.us_east_1a_public_cidr_block}"
  type              = "public"
  igw_id            = "${module.vpc.igw_id}"
  availability_zone = "us-east-1a"
  attributes        = ["us-east-1a"]
}

module "us_east_1a_private_subnets" {
  source            = "git::https://github.com/cloudposse/terraform-aws-named-subnets.git?ref=master"
  namespace         = "${var.namespace}"
  stage             = "${var.stage}"
  name              = "${var.name}"
  subnet_names      = ["charlie", "echo", "bravo"]
  vpc_id            = "${module.vpc.vpc_id}"
  cidr_block        = "${local.us_east_1a_private_cidr_block}"
  type              = "private"
  availability_zone = "us-east-1a"
  ngw_id            = "${module.us_east_1a_public_subnets.ngw_id}"
  attributes        = ["us-east-1a"]
}

module "us_east_1b_public_subnets" {
  source            = "git::https://github.com/cloudposse/terraform-aws-named-subnets.git?ref=master"
  namespace         = "${var.namespace}"
  stage             = "${var.stage}"
  name              = "${var.name}"
  subnet_names      = ["apples", "oranges", "grapes"]
  vpc_id            = "${module.vpc.vpc_id}"
  cidr_block        = "${local.us_east_1b_public_cidr_block}"
  type              = "public"
  igw_id            = "${module.vpc.igw_id}"
  availability_zone = "us-east-1b"
  attributes        = ["us-east-1b"]
}

module "us_east_1b_private_subnets" {
  source            = "git::https://github.com/cloudposse/terraform-aws-named-subnets.git?ref=master"
  namespace         = "${var.namespace}"
  stage             = "${var.stage}"
  name              = "${var.name}"
  subnet_names      = ["charlie", "echo", "bravo"]
  vpc_id            = "${module.vpc.vpc_id}"
  cidr_block        = "${local.us_east_1b_private_cidr_block}"
  type              = "private"
  availability_zone = "us-east-1b"
  ngw_id            = "${module.us_east_1b_public_subnets.ngw_id}"
  attributes        = ["us-east-1b"]
}

resource "aws_network_interface" "default" {
  subnet_id         = "${module.us_east_1b_public_subnets.subnet_ids[0]}"
  source_dest_check = "false"
  tags              = "${module.network_interface_label.id}
}

module "us_east_1b_private_subnets" {
  source            = "git::https://github.com/cloudposse/terraform-aws-named-subnets.git?ref=master"
  namespace         = "${var.namespace}"
  stage             = "${var.stage}"
  name              = "${var.name}"
  subnet_names      = ["charlie", "echo", "bravo"]
  vpc_id            = "${module.vpc.vpc_id}"
  cidr_block        = "${local.us_east_1b_private_cidr_block}"
  type              = "private"
  availability_zone = "us-east-1b"
  eni_id            = "${aws_network_interface.default.id}"
  attributes        = ["us-east-1b"]
}

```

## Caveat
You must use only one type of device for a default route gateway per route table. `ENI` or `NGW`

Given the following configuration (see the Simple example above)

```terraform
locals {
  public_cidr_block  = "${cidrsubnet(var.vpc_cidr, 1, 0)}"
  private_cidr_block = "${cidrsubnet(var.vpc_cidr, 1, 1)}"
}

module "public_subnets" {
  source            = "git::https://github.com/cloudposse/terraform-aws-named-subnets.git?ref=master"
  namespace         = "${var.namespace}"
  stage             = "${var.stage}"
  name              = "${var.name}"
  subnet_names      = ["web1", "web2", "web3"]
  vpc_id            = "${var.vpc_id}"
  cidr_block        = "${local.public_cidr_block}"
  type              = "public"
  availability_zone = "us-east-1a"
  igw_id            = "${var.igw_id}"
}

module "private_subnets" {
  source            = "git::https://github.com/cloudposse/terraform-aws-named-subnets.git?ref=master"
  namespace         = "${var.namespace}"
  stage             = "${var.stage}"
  name              = "${var.name}"
  subnet_names      = ["kafka", "cassandra", "zookeeper"]
  vpc_id            = "${var.vpc_id}"
  cidr_block        = "${local.private_cidr_block}"
  type              = "private"
  availability_zone = "us-east-1a"
  ngw_id            = "${module.public_subnets.ngw_id}"
}

output "private_named_subnet_ids" {
  value = "${module.private_subnets.named_subnet_ids}"
}

output "public_named_subnet_ids" {
  value = "${module.public_subnets.named_subnet_ids}"
}
```

the output Maps of subnet names to subnet IDs look like these

```terraform
public_named_subnet_ids = {
  web1 = subnet-ea58d78e
  web2 = subnet-556ee131
  web3 = subnet-6f54db0b
}
private_named_subnet_ids = {
  cassandra = subnet-376de253
  kafka = subnet-9e53dcfa
  zookeeper = subnet-a86fe0cc
}
```

and the created subnet IDs could be found by the subnet names using `map["key"]` or [`lookup(map, key, [default])`](https://www.terraform.io/docs/configuration/interpolation.html#lookup-map-key-default-),

for example:

`public_named_subnet_ids["web1"]`

`lookup(private_named_subnet_ids, "kafka")`



## Makefile Targets
```
Available targets:

  help                                This help screen
  help/all                            Display help for all targets
  lint                                Lint terraform code

```

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




## Related Projects

Check out these related projects.

- [terraform-aws-multi-az-subnets](https://github.com/cloudposse/terraform-aws-multi-az-subnets) - Terraform module for multi-AZ public and private subnets provisioning.
- [terraform-aws-dynamic-subnets](https://github.com/cloudposse/terraform-aws-dynamic-subnets) - Terraform module for public and private subnets provisioning in existing VPC
- [terraform-aws-vpc](https://github.com/cloudposse/terraform-aws-vpc) - Terraform Module that defines a VPC with public/private subnets across multiple AZs with Internet Gateways
- [terraform-aws-cloudwatch-flow-logs](https://github.com/cloudposse/terraform-aws-cloudwatch-flow-logs) - Terraform module for enabling flow logs for vpc and subnets.



## Help

**Got a question?**

File a GitHub [issue](https://github.com/cloudposse/terraform-aws-named-subnets/issues), send us an [email][email] or join our [Slack Community][slack].

## Commerical Support

Work directly with our team of DevOps experts via email, slack, and video conferencing. 

We provide *commercial support* for all of our [Open Source][github] projects. As a *Dedicated Support* customer, you have access to our team of subject matter experts at a fraction of the cost of a fulltime engineer. 

[![E-Mail](https://img.shields.io/badge/email-hello@cloudposse.com-blue.svg)](mailto:hello@cloudposse.com)

- **Questions.** We'll use a Shared Slack channel between your team and ours.
- **Troubleshooting.** We'll help you triage why things aren't working.
- **Code Reviews.** We'll review your Pull Requests and provide constructive feedback.
- **Bug Fixes.** We'll rapidly work to fix any bugs in our projects.
- **Build New Terraform Modules.** We'll develop original modules to provision infrastructure.
- **Cloud Architecture.** We'll assist with your cloud strategy and design.
- **Implementation.** We'll provide hands on support to implement our reference architectures. 


## Community Forum

Get access to our [Open Source Community Forum][slack] on Slack. It's **FREE** to join for everyone! Our "SweetOps" community is where you get to talk with others who share a similar vision for how to rollout and manage infrastructure. This is the best place to talk shop, ask questions, solicit feedback, and work together as a community to build *sweet* infrastructure.

## Contributing

### Bug Reports & Feature Requests

Please use the [issue tracker](https://github.com/cloudposse/terraform-aws-named-subnets/issues) to report any bugs or file feature requests.

### Developing

If you are interested in being a contributor and want to get involved in developing this project or [help out](https://github.com/orgs/cloudposse/projects/3) with our other projects, we would love to hear from you! Shoot us an [email](mailto:hello@cloudposse.com).

In general, PRs are welcome. We follow the typical "fork-and-pull" Git workflow.

 1. **Fork** the repo on GitHub
 2. **Clone** the project to your own machine
 3. **Commit** changes to your own branch
 4. **Push** your work back up to your fork
 5. Submit a **Pull Request** so that we can review your changes

**NOTE:** Be sure to merge the latest changes from "upstream" before making a pull request!


## Copyright

Copyright © 2017-2018 [Cloud Posse, LLC](https://cloudposse.com)



## License 

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) 

See [LICENSE](LICENSE) for full details.

    Licensed to the Apache Software Foundation (ASF) under one
    or more contributor license agreements.  See the NOTICE file
    distributed with this work for additional information
    regarding copyright ownership.  The ASF licenses this file
    to you under the Apache License, Version 2.0 (the
    "License"); you may not use this file except in compliance
    with the License.  You may obtain a copy of the License at

      https://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on an
    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
    KIND, either express or implied.  See the License for the
    specific language governing permissions and limitations
    under the License.









## Trademarks

All other trademarks referenced herein are the property of their respective owners.

## About

This project is maintained and funded by [Cloud Posse, LLC][website]. Like it? Please let us know at <hello@cloudposse.com>

[![Cloud Posse](https://cloudposse.com/logo-300x69.svg)](https://cloudposse.com)

We're a [DevOps Professional Services][hire] company based in Los Angeles, CA. We love [Open Source Software](https://github.com/cloudposse/)!

We offer paid support on all of our projects.  

Check out [our other projects][github], [apply for a job][jobs], or [hire us][hire] to help with your cloud strategy and implementation.

  [docs]: https://docs.cloudposse.com/
  [website]: https://cloudposse.com/
  [github]: https://github.com/cloudposse/
  [jobs]: https://cloudposse.com/jobs/
  [hire]: https://cloudposse.com/contact/
  [slack]: https://slack.cloudposse.com/
  [linkedin]: https://www.linkedin.com/company/cloudposse
  [twitter]: https://twitter.com/cloudposse/
  [email]: mailto:hello@cloudposse.com


### Contributors

|  [![Andriy Knysh][aknysh_avatar]][aknysh_homepage]<br/>[Andriy Knysh][aknysh_homepage] | [![Sergey Vasilyev][s2504s_avatar]][s2504s_homepage]<br/>[Sergey Vasilyev][s2504s_homepage] | [![Vladimir][SweetOps_avatar]][SweetOps_homepage]<br/>[Vladimir][SweetOps_homepage] | [![Konstantin B][comeanother_avatar]][comeanother_homepage]<br/>[Konstantin B][comeanother_homepage] |
|---|---|---|---|

  [aknysh_homepage]: https://github.com/aknysh
  [aknysh_avatar]: https://github.com/aknysh.png?size=150
  [s2504s_homepage]: https://github.com/s2504s
  [s2504s_avatar]: https://github.com/s2504s.png?size=150
  [SweetOps_homepage]: https://github.com/SweetOps
  [SweetOps_avatar]: https://github.com/SweetOps.png?size=150
  [comeanother_homepage]: https://github.com/comeanother
  [comeanother_avatar]: https://github.com/comeanother.png?size=150



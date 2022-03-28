# terraform-volterra-multicloud-networking

[![Lint Status](https://github.com/volterraedge/terraform-volterra-multicloud-networking/workflows/Lint/badge.svg)](https://github.com/volterraedge/terraform-volterra-multicloud-networking/actions)
[![LICENSE](https://img.shields.io/github/license/volterraedge/terraform-volterra-multicloud-networking)](https://github.com/volterraedge/terraform-volterra-multicloud-networking/blob/main/LICENSE)

This is a terraform module to create Volterra's Multi-Cloud Networking usecase. Read the [Multi-Cloud Networking usecase guide](https://docs.cloud.f5.com/docs/quick-start/multi-cloud-networking) to learn more.

---

## Overview

![Image of MCN Usecase](https://docs.cloud.f5.com/docs/static/c0e68c082aaa4c3eab45c0b0d667061f/63123/top-cns.webp)

---

## Prerequisites

### Volterra Account

* Signup For Volterra Account

  If you don't have a Volterra account. Please follow this link to [signup](https://console.ves.volterra.io/signup/)

* Download Volterra API credentials file

  Follow [how to generate API Certificate](https://volterra.io/docs/how-to/user-mgmt/credentials) to create API credentials

* Setup domain delegation

  Follow steps from this [link](https://volterra.io/docs/how-to/app-networking/domain-delegation) to create domain delegation

### Command Line Tools

* Install terraform

  For homebrew installed on macos, run below command to install terraform. For rest of the os follow the instructions from [this link](https://learn.hashicorp.com/tutorials/terraform/install-cli) to install terraform

  ```bash
  $ brew tap hashicorp/tap
  $ brew install hashicorp/tap/terraform

  # to update
  $ brew upgrade hashicorp/tap/terraform
  ```

* Export the API certificate password as environment variable

  ```bash
  export VES_P12_PASSWORD=<your credential password>
  ```

---

## Usage Example

```hcl
variable "api_url" {
  #--- UNCOMMENT FOR TEAM OR ORG TENANTS
  # default = "https://<TENANT-NAME>.console.ves.volterra.io/api"
  #--- UNCOMMENT FOR INDIVIDUAL/FREEMIUM
  # default = "https://console.ves.volterra.io/api"
}

# This points the absolute path of the api credentials file you downloaded from Volterra
variable "api_p12_file" {
  default = "path/to/your/api-creds.p12"
}

# Below is an option to pass access key and secret key as you probably don't want to save it in a file
# Use env variable before you run `terraform apply` command
# export TF_VAR_aws_access_key=<your aws access key>
# export TF_VAR_aws_secret_key=<your aws secret key>
variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "aws_region" {
  default = "us-east-2"
}

variable "aws_az" {
  default = "us-east-2a"
}

variable "namespace" {
  default = ""
}

variable "mnc_name" {}

variable "ssh_public_key" {}

variable "app_fqdn" {}

locals{
  namespace = var.namespace != "" ? var.namespace : var.name
}

terraform {
  required_providers {
    volterra = {
      source = "volterraedge/volterra"
      version = ">= 0.11.5"
    }
  }
}

provider "volterra" {
  api_p12_file = var.api_p12_file
  url          = var.api_url
}

module "mnc" {
  source              = "volterraedge/multicloud-networking/volterra"
  mcn_name            = var.name
  ssh_public_key      = var.ssh_public_key
  volterra_namespace  = local.namespace
  app_domain          = var.app_fqdn
  aws_secret_key      = var.aws_secret_key
  aws_access_key      = var.aws_access_key
  aws_region          = var.aws_region
  aws_az              = var.aws_az
  aws_vpc_cidr        = var.aws_vpc_cidr
  aws_subnet_ce_cidr  = var.aws_subnet_ce_cidr
  aws_subnet_eks_cidr = var.aws_subnet_eks_cidr
}
```

---

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.22.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 1.9 |
| <a name="requirement_local"></a> [local](#requirement\_local) | >= 2.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.0 |
| <a name="requirement_volterra"></a> [volterra](#requirement\_volterra) | >= 0.11.5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.22.0 |
| <a name="provider_null"></a> [null](#provider\_null) | >= 3.0 |
| <a name="provider_volterra"></a> [volterra](#provider\_volterra) | >= 0.11.5 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_instance.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_internet_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_key_pair.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_network_interface.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_interface) | resource |
| [aws_route.ipv4_default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.ipv6_default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table_association.workload](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.volterra_ce](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [null_resource.wait_for_aws_mns](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [volterra_aws_vpc_site.this](https://registry.terraform.io/providers/volterraedge/volterra/latest/docs/resources/aws_vpc_site) | resource |
| [volterra_cloud_credentials.aws](https://registry.terraform.io/providers/volterraedge/volterra/latest/docs/resources/cloud_credentials) | resource |
| [volterra_namespace.this](https://registry.terraform.io/providers/volterraedge/volterra/latest/docs/resources/namespace) | resource |
| [volterra_origin_pool.aws_client_ssh](https://registry.terraform.io/providers/volterraedge/volterra/latest/docs/resources/origin_pool) | resource |
| [volterra_tcp_loadbalancer.client_ssh](https://registry.terraform.io/providers/volterraedge/volterra/latest/docs/resources/tcp_loadbalancer) | resource |
| [volterra_tf_params_action.apply_aws_vpc](https://registry.terraform.io/providers/volterraedge/volterra/latest/docs/resources/tf_params_action) | resource |
| [volterra_virtual_network.global_vn](https://registry.terraform.io/providers/volterraedge/volterra/latest/docs/resources/virtual_network) | resource |
| [aws_instance.ce](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/instance) | data source |
| [aws_instance.voltmesh](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/instance) | data source |
| [aws_route_tables.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_tables) | data source |
| [volterra_namespace.this](https://registry.terraform.io/providers/volterraedge/volterra/latest/docs/data-sources/namespace) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_dns_list"></a> [allow\_dns\_list](#input\_allow\_dns\_list) | List of IP prefixes to be allowed | `list(string)` | <pre>[<br>  "8.8.8.8/32"<br>]</pre> | no |
| <a name="input_allow_tls_prefix_list"></a> [allow\_tls\_prefix\_list](#input\_allow\_tls\_prefix\_list) | Allow TLS prefix list | `list(string)` | <pre>[<br>  "gcr.io",<br>  "storage.googleapis.com",<br>  "docker.io",<br>  "docker.com",<br>  "amazonaws.com"<br>]</pre> | no |
| <a name="input_app_domain"></a> [app\_domain](#input\_app\_domain) | FQDN for the app. If you have delegated domain `prod.example.com`, then your app\_domain can be `<app_name>.prod.example.com` | `string` | n/a | yes |
| <a name="input_aws_access_key"></a> [aws\_access\_key](#input\_aws\_access\_key) | AWS Access Key. Programmable API access key needed for creating the site | `string` | n/a | yes |
| <a name="input_aws_az"></a> [aws\_az](#input\_aws\_az) | AWS Availability Zone in which the site will be created | `string` | n/a | yes |
| <a name="input_aws_client_instance_type"></a> [aws\_client\_instance\_type](#input\_aws\_client\_instance\_type) | AWS Client VM instance type | `string` | `"t2.micro"` | no |
| <a name="input_aws_instance_type"></a> [aws\_instance\_type](#input\_aws\_instance\_type) | AWS instance type used for the Volterra site | `string` | `"t3.2xlarge"` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS Region where Site will be created | `string` | n/a | yes |
| <a name="input_aws_secret_key"></a> [aws\_secret\_key](#input\_aws\_secret\_key) | AWS Secret Access Key. Programmable API secret access key needed for creating the site | `string` | n/a | yes |
| <a name="input_aws_subnet_ce_cidr"></a> [aws\_subnet\_ce\_cidr](#input\_aws\_subnet\_ce\_cidr) | Map to hold different CE cidr with key as name of subnet | `map(string)` | <pre>{<br>  "inside": "192.168.0.192/26",<br>  "outside": "192.168.0.0/25",<br>  "workload": "192.168.0.128/26"<br>}</pre> | no |
| <a name="input_aws_vpc_cidr"></a> [aws\_vpc\_cidr](#input\_aws\_vpc\_cidr) | AWS VPC CIDR, that will be used to create the vpc while creating the site | `string` | `"192.168.0.0/22"` | no |
| <a name="input_client_ami_id"></a> [client\_ami\_id](#input\_client\_ami\_id) | Client VM ami-id, this will be different per AWS region. [List of ubuntu ami-id's, could be found here](https://cloud-images.ubuntu.com/locator/ec2/) | `string` | `"ami-07a0844029df33d7d"` | no |
| <a name="input_client_disk_size"></a> [client\_disk\_size](#input\_client\_disk\_size) | Client VM disk size in GiB | `number` | `30` | no |
| <a name="input_client_ssh_port"></a> [client\_ssh\_port](#input\_client\_ssh\_port) | TCP lb listen port for ssh access to the clients | `number` | `2220` | no |
| <a name="input_deny_dns_list"></a> [deny\_dns\_list](#input\_deny\_dns\_list) | List of IP prefixes to be denied | `list(string)` | <pre>[<br>  "8.8.4.4/32"<br>]</pre> | no |
| <a name="input_enable_hsts"></a> [enable\_hsts](#input\_enable\_hsts) | Flag to enable hsts for HTTPS loadbalancer | `bool` | `false` | no |
| <a name="input_enable_redirect"></a> [enable\_redirect](#input\_enable\_redirect) | Flag to enable http redirect to HTTPS loadbalancer | `bool` | `true` | no |
| <a name="input_js_cookie_expiry"></a> [js\_cookie\_expiry](#input\_js\_cookie\_expiry) | Javascript cookie expiry time in seconds | `number` | `3600` | no |
| <a name="input_js_script_delay"></a> [js\_script\_delay](#input\_js\_script\_delay) | Javascript challenge delay in miliseconds | `number` | `5000` | no |
| <a name="input_mcn_name"></a> [mcn\_name](#input\_mcn\_name) | MCN Name. Also used as a prefix in names of related resources. | `string` | n/a | yes |
| <a name="input_site_disk_size"></a> [site\_disk\_size](#input\_site\_disk\_size) | Disk size in GiB | `number` | `80` | no |
| <a name="input_ssh_public_key"></a> [ssh\_public\_key](#input\_ssh\_public\_key) | SSH Public Key | `string` | n/a | yes |
| <a name="input_volterra_namespace"></a> [volterra\_namespace](#input\_volterra\_namespace) | Volterra app namespace where the object will be created. This cannot be system or shared ns. | `string` | n/a | yes |
| <a name="input_volterra_namespace_exists"></a> [volterra\_namespace\_exists](#input\_volterra\_namespace\_exists) | Flag to create or use existing volterra namespace | `string` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_client_ssh_access"></a> [aws\_client\_ssh\_access](#output\_aws\_client\_ssh\_access) | Linux command to ssh aws client |

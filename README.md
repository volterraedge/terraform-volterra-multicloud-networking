# terraform-volterra-multicloud-networking


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

variable "azure_client_id" {}
variable "azure_client_secret" {}
variable "azure_subscription_id" {}
variable "azure_tenant_id" {}

variable "azure_region" {
  default = "eastus"
}

variable "azure_az" {
	default = "1"
}

variable "namespace" {
  default = ""
}

variable "mnc_name" {}

variable "azure_resource_group" {}

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

  azure_client_id       = var.azure_client_id
  azure_client_secret   = var.azure_client_secret
  azure_subscription_id = var.azure_subscription_id
  azure_tenant_id       = var.azure_tenant_id
  azure_region          = var.azure_region
  azure_az              = var.azure_az
  azure_resource_group  = var.azure_resource_group
}
```
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
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | >= 3.0 |
| <a name="provider_volterra"></a> [volterra](#provider\_volterra) | >= 0.11.5 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vnet"></a> [vnet](#module\_vnet) | Azure/vnet/azurerm | n/a |

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
| [azurerm_linux_virtual_machine.green](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) | resource |
| [azurerm_linux_virtual_machine.red](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) | resource |
| [azurerm_network_interface.green](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_network_interface.red](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_network_security_group.allow_ce](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_resource_group.peer_vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_route.peer_vnet_route](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route) | resource |
| [azurerm_route_table.peer_vnet_route_table](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table) | resource |
| [null_resource.wait_for_aws_mns](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.wait_for_azure_mns](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [volterra_aws_vpc_site.this](https://registry.terraform.io/providers/volterraedge/volterra/latest/docs/resources/aws_vpc_site) | resource |
| [volterra_azure_vnet_site.this](https://registry.terraform.io/providers/volterraedge/volterra/latest/docs/resources/azure_vnet_site) | resource |
| [volterra_cloud_credentials.aws](https://registry.terraform.io/providers/volterraedge/volterra/latest/docs/resources/cloud_credentials) | resource |
| [volterra_cloud_credentials.azure](https://registry.terraform.io/providers/volterraedge/volterra/latest/docs/resources/cloud_credentials) | resource |
| [volterra_namespace.this](https://registry.terraform.io/providers/volterraedge/volterra/latest/docs/resources/namespace) | resource |
| [volterra_origin_pool.aws_client_ssh](https://registry.terraform.io/providers/volterraedge/volterra/latest/docs/resources/origin_pool) | resource |
| [volterra_tcp_loadbalancer.client_ssh](https://registry.terraform.io/providers/volterraedge/volterra/latest/docs/resources/tcp_loadbalancer) | resource |
| [volterra_tf_params_action.apply_aws_vpc](https://registry.terraform.io/providers/volterraedge/volterra/latest/docs/resources/tf_params_action) | resource |
| [volterra_tf_params_action.apply_az_vnet](https://registry.terraform.io/providers/volterraedge/volterra/latest/docs/resources/tf_params_action) | resource |
| [volterra_virtual_network.global_vn](https://registry.terraform.io/providers/volterraedge/volterra/latest/docs/resources/virtual_network) | resource |
| [aws_instance.ce](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/instance) | data source |
| [aws_instance.voltmesh](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/instance) | data source |
| [aws_route_tables.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_tables) | data source |
| [azurerm_network_interface.sli](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/network_interface) | data source |
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
| <a name="input_azure_az"></a> [azure\_az](#input\_azure\_az) | Azure Availability Zone in which the site will be created | `string` | n/a | yes |
| <a name="input_azure_client_id"></a> [azure\_client\_id](#input\_azure\_client\_id) | Client ID for your Azure service principal | `string` | n/a | yes |
| <a name="input_azure_client_secret"></a> [azure\_client\_secret](#input\_azure\_client\_secret) | Client Secret (alias password) for your Azure service principal | `string` | n/a | yes |
| <a name="input_azure_client_vnet_cidr"></a> [azure\_client\_vnet\_cidr](#input\_azure\_client\_vnet\_cidr) | Azure Client Vnet CIDR, that will be used to create the vpc while creating the site | `string` | `"10.0.0.0/22"` | no |
| <a name="input_azure_machine_type"></a> [azure\_machine\_type](#input\_azure\_machine\_type) | Azure Vnet Site machine type | `string` | `"Standard_D3_v2"` | no |
| <a name="input_azure_region"></a> [azure\_region](#input\_azure\_region) | Azure Region where Site will be created | `string` | n/a | yes |
| <a name="input_azure_resource_group"></a> [azure\_resource\_group](#input\_azure\_resource\_group) | Azure resource group where you want the site objects to be deployed, this has to be a new resource group | `string` | n/a | yes |
| <a name="input_azure_subnet_ce_cidr"></a> [azure\_subnet\_ce\_cidr](#input\_azure\_subnet\_ce\_cidr) | Map to hold different CE cidr with key as name of subnet | `map(string)` | <pre>{<br>  "inside": "10.0.0.192/26",<br>  "outside": "10.0.0.0/25",<br>  "workload": "10.0.0.128/26"<br>}</pre> | no |
| <a name="input_azure_subscription_id"></a> [azure\_subscription\_id](#input\_azure\_subscription\_id) | Subscription ID for your Azure service principal | `string` | n/a | yes |
| <a name="input_azure_tenant_id"></a> [azure\_tenant\_id](#input\_azure\_tenant\_id) | Tenant ID for your Azure service principal | `string` | n/a | yes |
| <a name="input_azure_vnet_cidr"></a> [azure\_vnet\_cidr](#input\_azure\_vnet\_cidr) | Azure Vnet CIDR, that will be used to create the vpc while creating the site | `string` | `"10.0.0.0/22"` | no |
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

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
      version = "0.4.0"
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

output "app_url" {
  value = module.mnc.app_url
}
```

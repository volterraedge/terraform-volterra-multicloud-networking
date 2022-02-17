variable "mcn_name" {
  type        = string
  description = "MCN Name. Also used as a prefix in names of related resources."
}

variable "aws_access_key" {
  type        = string
  description = "AWS Access Key. Programmable API access key needed for creating the site"
}

variable "aws_secret_key" {
  type        = string
  description = "AWS Secret Access Key. Programmable API secret access key needed for creating the site"
}

variable "aws_client_instance_type" {
  type        = string
  description = "AWS Client VM instance type"
  default     = "t2.micro"
}

variable "azure_client_id" {
  type        = string
  description = "Client ID for your Azure service principal"
}

variable "azure_client_secret" {
  type        = string
  description = "Client Secret (alias password) for your Azure service principal"
}

variable "azure_subscription_id" {
  type        = string
  description = "Subscription ID for your Azure service principal"
}

variable "azure_tenant_id" {
  type        = string
  description = "Tenant ID for your Azure service principal"
}

variable "azure_region" {
  type        = string
  description = "Azure Region where Site will be created"
}

variable "azure_az" {
  type        = string
  description = "Azure Availability Zone in which the site will be created"
}

variable "aws_region" {
  type        = string
  description = "AWS Region where Site will be created"
}

variable "aws_az" {
  type        = string
  description = "AWS Availability Zone in which the site will be created"
}

variable "site_disk_size" {
  type        = number
  description = "Disk size in GiB"
  default     = 80
}

variable "aws_instance_type" {
  type        = string
  description = "AWS instance type used for the Volterra site"
  default     = "t3.2xlarge"
}

variable "aws_vpc_cidr" {
  type        = string
  description = "AWS VPC CIDR, that will be used to create the vpc while creating the site"
  default     = "192.168.0.0/22"
}

variable "aws_subnet_ce_cidr" {
  type        = map(string)
  description = "Map to hold different CE cidr with key as name of subnet"
  default = {
    "outside"  = "192.168.0.0/25"
    "inside"   = "192.168.0.192/26"
    "workload" = "192.168.0.128/26"
  }
}

variable "client_ami_id" {
  type        = string
  description = "Client VM ami-id, this will be different per AWS region. [List of ubuntu ami-id's, could be found here](https://cloud-images.ubuntu.com/locator/ec2/)"
  default     = "ami-07a0844029df33d7d"
}

variable "client_disk_size" {
  type        = number
  description = "Client VM disk size in GiB"
  default     = 30
}

variable "azure_vnet_cidr" {
  type        = string
  description = "Azure Vnet CIDR, that will be used to create the vpc while creating the site"
  default     = "10.0.0.0/22"
}

variable "azure_client_vnet_cidr" {
  type        = string
  description = "Azure Client Vnet CIDR, that will be used to create the vpc while creating the site"
  default     = "10.0.0.0/22"
}

variable "azure_subnet_ce_cidr" {
  type        = map(string)
  description = "Map to hold different CE cidr with key as name of subnet"
  default = {
    "outside"  = "10.0.0.0/25"
    "inside"   = "10.0.0.192/26"
    "workload" = "10.0.0.128/26"
  }
}

variable "azure_resource_group" {
  type        = string
  description = "Azure resource group where you want the site objects to be deployed, this has to be a new resource group"
}

variable "azure_machine_type" {
  type        = string
  description = "Azure Vnet Site machine type"
  default     = "Standard_D3_v2"
}

variable "ssh_public_key" {
  type        = string
  description = "SSH Public Key"
}

variable "deny_dns_list" {
  type        = list(string)
  description = "List of IP prefixes to be denied"
  default     = ["8.8.4.4/32"]
}

variable "allow_dns_list" {
  type        = list(string)
  description = "List of IP prefixes to be allowed"
  default     = ["8.8.8.8/32"]
}

variable "allow_tls_prefix_list" {
  type        = list(string)
  description = "Allow TLS prefix list"
  default     = ["gcr.io", "storage.googleapis.com", "docker.io", "docker.com", "amazonaws.com"]
}

variable "app_domain" {
  type        = string
  description = "FQDN for the app. If you have delegated domain `prod.example.com`, then your app_domain can be `<app_name>.prod.example.com`"
}

variable "enable_hsts" {
  type        = bool
  description = "Flag to enable hsts for HTTPS loadbalancer"
  default     = false
}

variable "enable_redirect" {
  type        = bool
  description = "Flag to enable http redirect to HTTPS loadbalancer"
  default     = true
}

variable "js_script_delay" {
  type        = number
  description = "Javascript challenge delay in miliseconds"
  default     = 5000
}

variable "js_cookie_expiry" {
  type        = number
  description = "Javascript cookie expiry time in seconds"
  default     = 3600
}

variable "volterra_namespace_exists" {
  type        = string
  description = "Flag to create or use existing volterra namespace"
  default     = false
}

variable "volterra_namespace" {
  type        = string
  description = "Volterra app namespace where the object will be created. This cannot be system or shared ns."
}

variable "client_ssh_port" {
  type        = number
  description = "TCP lb listen port for ssh access to the clients"
  default     = 2220
}

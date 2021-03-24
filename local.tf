locals {
  aws_name           = format("%s-aws", var.mcn_name)
  azure_name         = format("%s-azure", var.mcn_name)
  namespace          = var.volterra_namespace_exists ? join("", data.volterra_namespace.this.*.name) : join("", volterra_namespace.this.*.name)
  azure_peer_subnets = [cidrsubnet(var.azure_client_vnet_cidr, 1, 0), cidrsubnet(var.azure_client_vnet_cidr, 1, 1)]
}

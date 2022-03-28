locals {
  aws_name           = format("%s-aws", var.mcn_name)
  namespace          = var.volterra_namespace_exists ? join("", data.volterra_namespace.this.*.name) : join("", volterra_namespace.this.*.name)
}

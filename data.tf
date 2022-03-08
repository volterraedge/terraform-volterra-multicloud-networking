data "aws_route_tables" "main" {
  depends_on = [volterra_tf_params_action.apply_aws_vpc]
  vpc_id     = aws_vpc.this.id
  filter {
    name   = "association.main"
    values = ["true"]
  }
}

data "aws_instance" "ce" {
  depends_on = [volterra_tf_params_action.apply_aws_vpc]
  filter {
    name   = "tag:ves-io-site-name"
    values = [local.aws_name]
  }
}

data "volterra_namespace" "this" {
  count = var.volterra_namespace_exists ? 1 : 0
  name  = var.volterra_namespace
}

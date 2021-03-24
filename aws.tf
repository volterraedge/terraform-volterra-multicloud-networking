provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}

resource "aws_vpc" "this" {
  cidr_block                       = var.aws_vpc_cidr
  assign_generated_ipv6_cidr_block = false
  enable_dns_support               = true
  enable_dns_hostnames             = true
  tags = {
    "Name"                                           = var.mcn_name
    "usecase"                                        = "multi-cloud-networking"
    format("kubernetes.io/cluster/%s", var.mcn_name) = "shared"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = {
    "Name"    = var.mcn_name
    "usecase" = "multi-cloud-networking"
  }
}

resource "aws_route" "ipv6_default" {
  route_table_id              = aws_vpc.this.main_route_table_id
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = aws_internet_gateway.this.id
  lifecycle {
    ignore_changes = [
      route_table_id
    ]
  }
}

resource "aws_route" "ipv4_default" {
  route_table_id         = aws_vpc.this.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
  lifecycle {
    ignore_changes = [
      route_table_id
    ]
  }
}

resource "aws_subnet" "volterra_ce" {
  for_each          = var.aws_subnet_ce_cidr
  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value
  availability_zone = var.aws_az
  tags = {
    "Name"        = format("%s-%s", var.mcn_name, each.key)
    "usecase"     = "multi-cloud-networking"
    "subnet-type" = each.key
  }
}

resource "aws_route_table_association" "workload" {
  subnet_id      = aws_subnet.volterra_ce["workload"].id
  route_table_id = element(tolist(data.aws_route_tables.main.ids), 0)
}

resource "aws_security_group" "this" {
  name        = "security-group-allow-voltmesh-node"
  description = "Allows connectivity between voltmesh node and client instance"
  vpc_id      = aws_vpc.this.id
  tags = {
    "Name"    = format("%s-sg", var.mcn_name)
    "usecase" = "multi-cloud-networking"
  }
  depends_on = [
    aws_internet_gateway.this,
  ]

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [lookup(var.aws_subnet_ce_cidr, "inside", "")]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_network_interface" "this" {
  subnet_id       = aws_subnet.volterra_ce["workload"].id
  security_groups = [aws_security_group.this.id]
  tags = {
    "Name"    = format("%s-eni", var.mcn_name)
    "usecase" = "multi-cloud-networking"
  }
}

resource "aws_key_pair" "this" {
  key_name   = format("%s-key", var.mcn_name)
  public_key = var.ssh_public_key
}


resource "aws_instance" "this" {
  depends_on    = [aws_key_pair.this]
  ami           = var.client_ami_id
  instance_type = var.aws_client_instance_type
  monitoring    = "false"
  key_name      = format("%s-key", var.mcn_name)

  tags = {
    "Name"    = format("%s-client", var.mcn_name)
    "usecase" = "multi-cloud-networking"
  }

  root_block_device {
    volume_size = var.client_disk_size
  }

  network_interface {
    network_interface_id = aws_network_interface.this.id
    device_index         = 0
  }

  timeouts {
    create = "60m"
    delete = "60m"
  }
}

data "aws_instance" "voltmesh" {
  depends_on = [volterra_tf_params_action.apply_aws_vpc]
  filter {
    name   = "tag:Name"
    values = ["master-0"]
  }
  filter {
    name   = "vpc-id"
    values = [aws_vpc.this.id]
  }
}


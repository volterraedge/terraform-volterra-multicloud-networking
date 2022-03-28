resource "volterra_cloud_credentials" "aws" {
  name        = format("%s-cred", local.aws_name)
  description = format("AWS credential will be used to create site %s", local.aws_name)
  namespace   = "system"
  aws_secret_key {
    access_key = var.aws_access_key
    secret_key {
      clear_secret_info {
        url = "string:///${base64encode(var.aws_secret_key)}"
      }
    }
  }
}

resource "volterra_virtual_network" "global_vn" {
  name                      = var.mcn_name
  namespace                 = "system"
  global_network            = true
  site_local_inside_network = false
  site_local_network        = false
}

resource "volterra_aws_vpc_site" "this" {
  name       = local.aws_name
  namespace  = "system"
  aws_region = var.aws_region
  aws_cred {
    name      = volterra_cloud_credentials.aws.name
    namespace = "system"
  }
  vpc {
    vpc_id = aws_vpc.this.id
  }
  disk_size     = var.site_disk_size
  instance_type = var.aws_instance_type

  ingress_egress_gw {
    aws_certified_hw = "aws-byol-multi-nic-voltmesh"
    az_nodes {
      aws_az_name            = var.aws_az
      reserved_inside_subnet = false
      inside_subnet {
        existing_subnet_id = aws_subnet.volterra_ce["inside"].id
      }
      workload_subnet {
        existing_subnet_id = aws_subnet.volterra_ce["workload"].id
      }
      outside_subnet {
        existing_subnet_id = aws_subnet.volterra_ce["outside"].id
      }
    }
    inside_static_routes {
      static_route_list {
        simple_static_route = lookup(var.aws_subnet_ce_cidr, "workload", "")
      }
    }
    global_network_list {
      global_network_connections {
        sli_to_global_dr {
          global_vn {
            name      = volterra_virtual_network.global_vn.name
            namespace = "system"
          }
        }
      }
    }
    no_global_network        = false
    no_outside_static_routes = true
    no_inside_static_routes  = false
    no_network_policy        = true
    no_forward_proxy         = false
    forward_proxy_allow_all  = true
  }
  logs_streaming_disabled = true
  ssh_key                 = var.ssh_public_key
  lifecycle {
    ignore_changes = [labels]
  }
}

resource "null_resource" "wait_for_aws_mns" {
  triggers = {
    depends = volterra_aws_vpc_site.this.id
  }
}

resource "volterra_tf_params_action" "apply_aws_vpc" {
  depends_on       = [null_resource.wait_for_aws_mns]
  site_name        = local.aws_name
  site_kind        = "aws_vpc_site"
  action           = "apply"
  wait_for_action  = true
  ignore_on_update = true
}

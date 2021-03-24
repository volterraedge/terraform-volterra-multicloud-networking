resource "volterra_namespace" "this" {
  count = var.volterra_namespace_exists ? 0 : 1
  name  = var.volterra_namespace
}

resource "volterra_origin_pool" "aws_client_ssh" {
  name      = format("%s-ssh", local.aws_name)
  namespace = local.namespace
  origin_servers {
    private_name {
      dns_name        = aws_instance.this.private_dns
      inside_network  = true
      outside_network = false
      site_locator {
        site {
          name      = volterra_aws_vpc_site.this.name
          namespace = "system"
        }
      }
    }
  }
  no_tls                 = true
  port                   = 22
  same_as_endpoint_port  = true
  loadbalancer_algorithm = "LB_OVERRIDE"
  endpoint_selection     = "LOCAL_PREFERRED"
}

resource "volterra_tcp_loadbalancer" "client_ssh" {
  name                 = format("%s-ssh", local.aws_name)
  namespace            = local.namespace
  listen_port          = var.client_ssh_port
  with_sni             = false
  dns_volterra_managed = false
  advertise_custom {
    advertise_where {
      site {
        network = "SITE_NETWORK_OUTSIDE"
        site {
          name      = volterra_aws_vpc_site.this.name
          namespace = "system"
        }
      }
      port = var.client_ssh_port
    }
  }
  origin_pools_weights {
    pool {
      name = volterra_origin_pool.aws_client_ssh.name
    }
    weight = 1
  }
  do_not_advertise               = false
  hash_policy_choice_round_robin = true
}

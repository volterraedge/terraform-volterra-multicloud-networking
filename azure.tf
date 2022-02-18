provider "azurerm" {
  features {}
  subscription_id = var.azure_subscription_id
  client_id       = var.azure_client_id
  client_secret   = var.azure_client_secret
  tenant_id       = var.azure_tenant_id
}

resource "azurerm_resource_group" "peer_vnet" {
  name     = format("%s-peer", var.azure_resource_group)
  location = var.azure_region
}

resource "azurerm_network_security_group" "allow_ce" {
  name                = "allow-ce"
  resource_group_name = azurerm_resource_group.peer_vnet.name
  location            = azurerm_resource_group.peer_vnet.location

  security_rule {
    name                       = "allow-ingress-ce"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = lookup(var.azure_subnet_ce_cidr, "inside", "")
    destination_address_prefix = "*"
  }

}

module "vnet" {
  source              = "Azure/vnet/azurerm"
  resource_group_name = azurerm_resource_group.peer_vnet.name
  address_space       = [var.azure_client_vnet_cidr]
  subnet_prefixes     = local.azure_peer_subnets
  subnet_names        = ["subnet1", "subnet2"]

  nsg_ids = {
    subnet1 = azurerm_network_security_group.allow_ce.id
    subnet2 = azurerm_network_security_group.allow_ce.id
  }

  route_tables_ids = {
    subnet1 = azurerm_route_table.peer_vnet_route_table.id
    subnet2 = azurerm_route_table.peer_vnet_route_table.id
  }


  tags = {
    "Name"    = format("%s", var.mcn_name)
    "usecase" = "multi-cloud-networking"
  }
}

data "azurerm_network_interface" "sli" {
  depends_on = [
    volterra_tf_params_action.apply_az_vnet
  ]
  name                = "master-0-sli"
  resource_group_name = var.azure_resource_group
}

resource "azurerm_route_table" "peer_vnet_route_table" {
  name                = "peer-vnet-route-table"
  resource_group_name = azurerm_resource_group.peer_vnet.name
  location            = azurerm_resource_group.peer_vnet.location
}

resource "azurerm_route" "peer_vnet_route" {
  name                = "peer-vnet-route"
  resource_group_name = azurerm_resource_group.peer_vnet.name
  route_table_name    = azurerm_route_table.peer_vnet_route_table.name
  address_prefix      = "0.0.0.0/0"
  next_hop_type       = "VirtualAppliance"
  next_hop_in_ip_address = data.azurerm_network_interface.sli.private_ip_address
}

resource "azurerm_network_interface" "green" {
  name                = "green-nic"
  location            = azurerm_resource_group.peer_vnet.location
  resource_group_name = azurerm_resource_group.peer_vnet.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = element(module.vnet.vnet_subnets, 0)
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "red" {
  name                = "red-nic"
  location            = azurerm_resource_group.peer_vnet.location
  resource_group_name = azurerm_resource_group.peer_vnet.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = element(module.vnet.vnet_subnets, 1)
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "green" {
  name                = "green-machine"
  resource_group_name = azurerm_resource_group.peer_vnet.name
  location            = azurerm_resource_group.peer_vnet.location
  size                = "Standard_F2"
  admin_username      = "azureuser"
  network_interface_ids = [
    azurerm_network_interface.green.id,
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}

resource "azurerm_linux_virtual_machine" "red" {
  name                = "red-machine"
  resource_group_name = azurerm_resource_group.peer_vnet.name
  location            = azurerm_resource_group.peer_vnet.location
  size                = "Standard_F2"
  admin_username      = "azureuser"
  network_interface_ids = [
    azurerm_network_interface.red.id,
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}


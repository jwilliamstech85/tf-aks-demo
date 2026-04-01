# Create the resource group
resource "azurerm_resource_group" "hub_vnet_rg" {
  name     = lower("${var.hub_vnet_rg_name}-${local.environment}-${var.vnet_rg_suffix}")
  location = var.hub_location
  tags     = merge(local.default_tags, var.vnet_tags)
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

# Create hub virtual network (Management vnet)
resource "azurerm_virtual_network" "hub_vnet" {
  name                = lower("${var.hub_vnet_name}-${local.environment}-${var.vnet_suffix}")
  address_space       = var.hub_vnet_address_space
  resource_group_name = azurerm_resource_group.hub_vnet_rg.name
  location            = azurerm_resource_group.hub_vnet_rg.location
  depends_on = [
    azurerm_resource_group.hub_vnet_rg,
  ]
}

//Create hub vnet gateway subnet
resource "azurerm_subnet" "hub_gateway" {
  name                 = var.hub_gateway_subnet_name
  resource_group_name  = azurerm_virtual_network.hub_vnet.resource_group_name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes     = var.hub_gateway_subnet_address_prefixes
  depends_on = [
    azurerm_virtual_network.hub_vnet
  ]
}

// Create hub bastion host subnet
resource "azurerm_subnet" "hub_bastion_subnet" {
  name                                          = var.hub_bastion_subnet_name
  resource_group_name                           = azurerm_virtual_network.hub_vnet.resource_group_name
  virtual_network_name                          = azurerm_virtual_network.hub_vnet.name
  address_prefixes                              = var.hub_bastion_subnet_address_prefixes
  private_endpoint_network_policies             = "Disabled"
  private_link_service_network_policies_enabled = false
  depends_on = [
    azurerm_virtual_network.hub_vnet
  ]
}

// jumpbox VM server subnet
resource "azurerm_subnet" "jumpbox_subnet" {
  name                                          = var.jumpbox_subnet_name
  resource_group_name                           = azurerm_virtual_network.hub_vnet.resource_group_name
  virtual_network_name                          = azurerm_virtual_network.hub_vnet.name
  address_prefixes                              = var.jumpbox_subnet_address_prefix
  private_endpoint_network_policies             = "Disabled"
  private_link_service_network_policies_enabled = false
  depends_on = [
    azurerm_virtual_network.hub_vnet
  ]
}

// Create hub application gateway subnet
resource "azurerm_subnet" "appgtw" {
  name                                          = lower("${var.appgtw_subnet_name}-${var.subnet_suffix}")
  resource_group_name                           = azurerm_virtual_network.hub_vnet.resource_group_name
  virtual_network_name                          = azurerm_virtual_network.hub_vnet.name
  address_prefixes                              = var.appgtw_address_prefixes
  private_endpoint_network_policies             = "Disabled"
  private_link_service_network_policies_enabled = false
  depends_on = [
    azurerm_virtual_network.hub_vnet
  ]
}

// Create hub azure firewall subnet
resource "azurerm_subnet" "firewall" {
  name                                          = var.hub_firewall_subnet_name
  resource_group_name                           = azurerm_virtual_network.hub_vnet.resource_group_name
  virtual_network_name                          = azurerm_virtual_network.hub_vnet.name
  address_prefixes                              = var.hub_firewall_subnet_address_prefixes
  private_endpoint_network_policies             = "Disabled"
  private_link_service_network_policies_enabled = false
  depends_on = [
    azurerm_virtual_network.hub_vnet
  ]
}

# Create spoke virtual network
resource "azurerm_virtual_network" "spoke_vnet" {
  name                = lower("${var.spoke_vnet_name}-${local.environment}-${var.vnet_suffix}")
  address_space       = var.spoke_vnet_address_space
  resource_group_name = azurerm_resource_group.hub_vnet_rg.name
  location            = azurerm_resource_group.hub_vnet_rg.location
  depends_on = [
    azurerm_resource_group.hub_vnet_rg,
  ]
}

// gateway subnet
/*resource "azurerm_subnet" "gateway" {
  name                 = "gateway"
  resource_group_name  = azurerm_virtual_network.hub_vnet.resource_group_name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes     = var.gateway_subnet_address_prefixes
  depends_on = [
    azurerm_virtual_network.hub_vnet
  ]
}*/

// VPN gateway subnet
resource "azurerm_subnet" "vpn_gateway" {
  name                 = "VPNGatewaySubnet"
  resource_group_name  = azurerm_virtual_network.spoke_vnet.resource_group_name
  virtual_network_name = azurerm_virtual_network.spoke_vnet.name
  address_prefixes     = var.vpn_gateway_subnet_address_prefixes
  depends_on = [
    azurerm_virtual_network.spoke_vnet
  ]
}

// postgreSQL subnet
resource "azurerm_subnet" "psql" {
  name                                          = lower("${var.psql_subnet_name}-${var.subnet_suffix}")
  resource_group_name                           = azurerm_virtual_network.spoke_vnet.resource_group_name
  virtual_network_name                          = azurerm_virtual_network.spoke_vnet.name
  address_prefixes                              = var.psql_address_prefixes
  private_endpoint_network_policies             = "Disabled"
  private_link_service_network_policies_enabled = false
  service_endpoints                             = ["Microsoft.Storage"]
  delegation {
    name = "fs"
    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
  depends_on = [
    azurerm_virtual_network.spoke_vnet
  ]
}

// aks subnet
resource "azurerm_subnet" "aks" {
  name                                          = lower("${var.aks_subnet_name}-${var.subnet_suffix}")
  resource_group_name                           = azurerm_virtual_network.spoke_vnet.resource_group_name
  virtual_network_name                          = azurerm_virtual_network.spoke_vnet.name
  address_prefixes                              = var.aks_address_prefixes
  private_endpoint_network_policies             = "Disabled"
  private_link_service_network_policies_enabled = false
  depends_on = [
    azurerm_virtual_network.spoke_vnet
  ]
}
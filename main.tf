//Resource Group
module "rg" {
  source = "./modules/resource_groups"
  #rg_name          = local.rg_name
  #rg_location      = var.primary_location
}

module "law" {
  source = "./modules/log_analytics_workspaces"
}

module "network" {
  source                               = "./modules/network"
  vnet_rg_name                         = var.vnet_rg_name
  vnet_location                        = var.vnet_location
  hub_vnet_name                        = var.hub_vnet_name
  hub_vnet_address_space               = var.hub_vnet_address_space
  hub_gateway_subnet_name              = var.hub_gateway_subnet_name
  hub_gateway_subnet_address_prefixes  = var.hub_gateway_subnet_address_prefixes
  hub_bastion_subnet_name              = var.hub_bastion_subnet_name
  hub_bastion_subnet_address_prefixes  = var.hub_bastion_subnet_address_prefixes
  spoke_vnet_name                      = var.spoke_vnet_name
  spoke_vnet_address_space             = var.spoke_vnet_address_space
  jumpbox_subnet_name                  = var.jumpbox_subnet_name
  jumpbox_subnet_address_prefix        = var.jumpbox_subnet_address_prefix
  aks_subnet_name                      = var.aks_subnet_name
  aks_address_prefixes                 = var.aks_address_prefixes
  psql_subnet_name                     = var.psql_subnet_name
  psql_address_prefixes                = var.psql_address_prefixes
  appgtw_subnet_name                   = var.appgtw_subnet_name
  appgtw_address_prefixes              = var.appgtw_address_prefixes
  gateway_subnet_address_prefixes      = var.gateway_subnet_address_prefixes
  vpn_gateway_subnet_address_prefixes  = var.vpn_gateway_subnet_address_prefixes
  hub_firewall_subnet_name             = var.hub_firewall_subnet_name
  hub_firewall_subnet_address_prefixes = var.hub_firewall_subnet_address_prefixes


}
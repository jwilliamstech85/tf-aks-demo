# ========================== resource group ===============================
module "rg" {
  source = "./modules/resource_groups"
  #rg_name          = local.rg_name
  #rg_location      = var.primary_location
}

# ========================== log analytics workspace ======================
module "law" {
  source                           = "./modules/log_analytics_workspaces"
  log_analytics_workspace_location = var.log_analytics_workspace_location
  log_analytics_workspace_rg_name  = var.log_analytics_workspace_rg_name
  log_analytics_workspace_name     = var.log_analytics_workspace_name
  log_analytics_workspace_sku      = var.log_analytics_workspace_sku
  log_analytics_retention_days     = var.log_analytics_retention_days
}


# ========================== virtual netowrking ==========================
module "network" {
  source                               = "./modules/network"
  hub_vnet_rg_name                     = var.hub_vnet_rg_name
  hub_location                         = var.hub_location
  hub_vnet_location                    = var.hub_location
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

# ========================== azure container registry =====================
module "acr" {
  source                       = "./modules/azure_container_registry"
  acr_name                     = var.acr_name
  acr_rg_name                  = var.acr_rg_name
  acr_location                 = var.acr_location
  acr_admin_enabled            = var.acr_admin_enabled
  acr_sku                      = var.acr_sku
  acr_data_endpoint_enabled    = var.acr_data_endpoint_enabled
  acr_georeplication_locations = var.acr_georeplication_locations
  pe_acr_subresource_names     = var.pe_acr_subresource_names
  output_law_id                = module.law.log_analytics_workspace_id
  hub_vnet_rg_name             = module.network.hub_vnet_rg_name
  hub_vnet_name                = module.network.hub_vnet_name
  hub_vnet_id                  = module.network.hub_vnet_id
  bastion_subnet_id            = module.network.hub_bastion_subnet_id
  #acr_log_analytics_retention_days = var.acr_log_analytics_retention_days

}

module "bastion" {
  source              = "./modules/bastion"
  bastion_name        = var.bastion_name
  bastion_pip_name    = var.bastion_pip_name
  bastion_subnet_id   = module.network.hub_bastion_subnet_id
  bastion_location    = module.network.hub_location
  bastion_rg_name     = module.network.hub_vnet_rg_name
  bastion_subnet_name = module.network.hub_bastion_subnet_name
  bastion_sku         = var.bastion_sku
}

module "jumpbox" {
  source                 = "./modules/jumpbox"
  jumpbox_location       = module.network.hub_location
  jumpbox_rg_name        = module.network.hub_vnet_rg_name
  jumpbox_subnet_id      = module.network.jumpbox_subnet_id
  jumpbox_admin_username = var.jumpbox_admin_username
  jumpbox_admin_password = var.jumpbox_admin_password
  nsg_allowed_ip_range   = var.nsg_allowed_ip_range
}

/*module "appgateway" {
  source                 = "./modules/application_gateway"

  appgtw_name            = var.appgtw_name
  appgtw_sku_size        = var.appgtw_sku_size
  appgtw_sku_tier        = var.appgtw_sku_tier
  appgtw_sku_capacity    = var.appgtw_sku_capacity
  appgtw_pip_name        = var.appgtw_pip_name
  pip_allocation_method  = var.pip_allocation_method
  pip_sku                = var.pip_sku
  appgtw_pip_location    = var.appgtw_pip_location

  depends_on = [
    module.rg,
    module.network,
  ]
}*/
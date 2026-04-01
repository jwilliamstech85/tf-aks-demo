// ========================== virtual netowrking ==========================
output "hub_vnet_rg_name" {
  description = "Specifies the name of the virtual network resource group"
  value       = azurerm_resource_group.hub_vnet_rg.name
}

output "hub_rg_location" {
  description = "Specifies the location of the virtual network resource group"
  value       = azurerm_resource_group.hub_vnet_rg.location
}

output "hub_location" {
  description = "Specifies the location of the hub resource group"
  value       = azurerm_resource_group.hub_vnet_rg.location
}

output "hub_vnet_name" {
  description = "Specifies the name of the virtual network"
  value       = azurerm_virtual_network.hub_vnet.name
}

output "hub_vnet_id" {
  description = "Specifies the resource id of the virtual network"
  value       = azurerm_virtual_network.hub_vnet.id
}

output "subnet_hub_gateway_id" {
  description = "Specifies the resource id of the gateway subnets"
  value       = azurerm_subnet.hub_gateway.id
}

output "subnet_appgtw_id" {
  description = "Specifies the resource id of the appgtw subnets"
  value       = azurerm_subnet.appgtw.id
}

output "subnet_psql_id" {
  description = "Specifies the resource id of the psql subnets"
  value       = azurerm_subnet.psql.id
}

output "subnet_aks_id" {
  description = "Specifies the resource id of the tenantmgmt subnets"
  value       = azurerm_subnet.aks.id
}

output "hub_bastion_subnet_name" {
  description = "Specifies the name of the bastion subnet"
  value       = azurerm_subnet.hub_bastion_subnet.name
}

output "hub_bastion_subnet_id" {
  description = "Specifies the resource id of the bastion subnet"
  value       = azurerm_subnet.hub_bastion_subnet.id
}

output "jumpbox_subnet_id" {
  description = "Specifies the resource id of the jumpbox subnet"
  value       = azurerm_subnet.jumpbox_subnet.id
}

/*output "appgtw_address_prefixes" {
  description = "Specifies the address prefixes of the app gateway subnet"
  value       = azurerm_subnet.appgtw.address_prefixes
}*/
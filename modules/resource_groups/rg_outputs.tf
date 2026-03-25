output "rg_name" {
  description = "The name of the created Resource Group"
  value       = azurerm_resource_group.rg.name
}

output "rg_id" {
  description = "The ID of the created Resource Group"
  value       = azurerm_resource_group.rg.id
}
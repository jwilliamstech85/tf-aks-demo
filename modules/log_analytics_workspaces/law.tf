# Create Log Analytics Workspace RG
resource "azurerm_resource_group" "law" {
  name     = lower("${var.log_analytics_workspace_rg_name}-${local.environment}-${var.law_rg_suffix}")
  location = var.log_analytics_workspace_location
  tags     = merge(local.default_tags, var.log_analytics_tags)
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

# Create Log Analytics Workspace 
resource "azurerm_log_analytics_workspace" "law" {
  name                = lower("${var.log_analytics_workspace_name}-${local.environment}-${var.log_analytics_workspace_suffix}")
  resource_group_name = azurerm_resource_group.law.name
  location            = var.log_analytics_workspace_location
  sku                 = var.log_analytics_workspace_sku
  retention_in_days   = var.log_analytics_retention_days != "" ? var.log_analytics_retention_days : null
  tags                = merge(local.default_tags, var.log_analytics_tags)
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
  depends_on = [
    azurerm_resource_group.law,
  ]
}

# Create log analytics workspace solution
resource "azurerm_log_analytics_solution" "law_solution" {
  for_each              = var.solution_plan_map
  solution_name         = each.value.solution_name
  resource_group_name   = azurerm_resource_group.law.name
  location              = var.log_analytics_workspace_location
  workspace_resource_id = azurerm_log_analytics_workspace.law.id
  workspace_name        = azurerm_log_analytics_workspace.law.name
  plan {
    product   = each.value.product
    publisher = each.value.publisher
  }
  tags = merge(local.default_tags, var.log_analytics_tags)
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
  depends_on = [
    azurerm_log_analytics_workspace.law,
  ]
}
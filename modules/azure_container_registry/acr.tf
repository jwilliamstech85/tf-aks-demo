# Create the resource group
resource "azurerm_resource_group" "acr_rg" {
  name     = lower("${var.acr_rg_name}-${local.environment}-${var.acr_suffix}")
  location = var.acr_location
  tags     = merge(local.default_tags)
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

# Create ACR user assigned identity
resource "azurerm_user_assigned_identity" "acr_identity" {
  resource_group_name = azurerm_resource_group.acr_rg.name
  location            = azurerm_resource_group.acr_rg.location
  tags                = merge(local.default_tags, var.acr_tags)

  name = "${var.acr_name}Identity"
  depends_on = [
    azurerm_resource_group.acr_rg,
  ]
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

# Create the Container Registry
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.acr_rg.name
  location            = azurerm_resource_group.acr_rg.location
  sku                 = var.acr_sku
  admin_enabled       = var.acr_admin_enabled
  # zone_redundancy_enabled = true
  data_endpoint_enabled = var.acr_data_endpoint_enabled
  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.acr_identity.id
    ]
  }

  # dynamic "georeplications" {
  #   for_each = var.acr_georeplication_locations

  #   content {
  #     location = georeplications.value
  #     tags     = merge(local.default_tags, var.acr_tags)
  #   }
  # }
  tags = merge(local.default_tags, var.acr_tags)
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
  depends_on = [
    azurerm_resource_group.acr_rg,
    var.output_law_id
  ]
}

# create Diagnostics Settings for ACR
resource "azurerm_monitor_diagnostic_setting" "diag_acr" {
  name                       = "DiagnosticsSettings"
  target_resource_id         = azurerm_container_registry.acr.id
  log_analytics_workspace_id = var.output_law_id

  enabled_log {
    category = "ContainerRegistryRepositoryEvents"
  }

  enabled_log {
    category = "ContainerRegistryLoginEvents"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}

# Create private DNS zone for Azure container registry
resource "azurerm_private_dns_zone" "pdz_acr" {
  name                = "privatelink.azurecr.io"
  resource_group_name = var.hub_vnet_rg_name
  tags                = merge(local.default_tags)

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
  depends_on = [
    var.hub_vnet_name
  ]
}

# Create private virtual network link to Virtual Network
resource "azurerm_private_dns_zone_virtual_network_link" "acr_pdz_vnet_link" {
  name                  = "privatelink_to_${var.hub_vnet_name}"
  resource_group_name   = var.hub_vnet_rg_name
  virtual_network_id    = var.hub_vnet_id
  private_dns_zone_name = azurerm_private_dns_zone.pdz_acr.name

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
  depends_on = [
    var.hub_vnet_rg_name,
    var.hub_vnet_name,
    azurerm_private_dns_zone.pdz_acr
  ]
}

# Create private endpoint for Azure container registry
/*resource "azurerm_private_endpoint" "pe_acr" {
  name                = lower("${azurerm_container_registry.acr.name}-${var.pe_suffix}")
  location            = azurerm_container_registry.acr.location
  resource_group_name = azurerm_container_registry.acr.resource_group_name
  subnet_id           = var.bastion_subnet_id
  tags                = merge(local.default_tags, var.acr_tags)

  private_service_connection {
    name                           = "${azurerm_container_registry.acr.name}-${var.pe_suffix}-connection"
    private_connection_resource_id = azurerm_container_registry.acr.id
    is_manual_connection           = false
    subresource_names              = var.pe_acr_subresource_names
    #request_message                = "PL" #optional message to the owner of the service when requesting connection approval, requires is_manual_connection set to "true"
  }

  private_dns_zone_group {
    name                 = "default" //var.pe_acr_private_dns_zone_group_name
    private_dns_zone_ids = [azurerm_private_dns_zone.pdz_acr.id]
  }

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
  depends_on = [
    azurerm_container_registry.acr,
    azurerm_private_dns_zone.pdz_acr,
  ]
}*/
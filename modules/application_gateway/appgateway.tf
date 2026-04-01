# Create public ip address for Application Gateway
resource "azurerm_public_ip" "appgtw_pip" {
  name                = lower("${var.appgtw_pip_name}-${local.environment}-${var.appgtw_public_ip_suffix}")
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.appgtw_pip_location
  allocation_method   = var.pip_allocation_method
  sku                 = var.pip_sku

  tags = merge(local.default_tags)
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
  depends_on = [
    azurerm_resource_group.rg,
  ]
}

# Create Application Gateway using terraform
resource "azurerm_application_gateway" "appgtw" {
  name                = lower("${var.appgtw_name}-${local.environment}-${var.appgtw_suffix}")
  resource_group_name = var.appgtw_rg_name
  location            = var.appgtw_location

  sku {
    name     = var.appgtw_sku_size
    tier     = var.appgtw_sku_tier
    capacity = var.appgtw_sku_capacity
  }
  waf_configuration {
    firewall_mode    = var.waf_config_firewall_mode
    enabled          = var.waf_config_enable
    rule_set_version = 3.1
  }
  gateway_ip_configuration {
    name      = local.gateway_ip_configuration_name
    subnet_id = azurerm_subnet.appgtw.id
  }
  frontend_port {
    name = local.frontend_port_name
    port = 80
  }
  frontend_port {
    name = "httpsPort"
    port = 443
  }
  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.appgtw_pip.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.backend_http_settings_name
    cookie_based_affinity = "Disabled"
    path                  = "/path1/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
    # connection_draining { //TODO: review this
    #   enabled = true
    #   drain_timeout_sec = 30
    # }
  }

  http_listener {
    name                           = local.http_listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.http_listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.backend_http_settings_name
    priority                   = 1
  }
  tags = merge(local.default_tags)
  lifecycle {
    ignore_changes = [
      tags,
      tags["ingress-for-aks-cluster-id"],
      tags["managed-by-k8s-ingress"],
      backend_address_pool,
      backend_http_settings,
      frontend_ip_configuration,
      gateway_ip_configuration,
      frontend_port,
      http_listener,
      probe,
      request_routing_rule,
      redirect_configuration,
      ssl_certificate,
      ssl_policy,
      waf_configuration,
      autoscale_configuration,
      url_path_map,
      rewrite_rule_set
    ]
  }
  depends_on = [
    azurerm_public_ip.appgtw_pip
  ]
}

# Create Diagnostic Settings for Application Gateway
resource "azurerm_monitor_diagnostic_setting" "diag_apptw" {
  name                       = "${azurerm_application_gateway.appgtw.name}-${var.diag_suffix}"
  target_resource_id         = azurerm_application_gateway.appgtw.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.workspace.id
  # dynamic "log" {
  #   for_each = local.diag_appgtw_logs
  #   content {
  #     category = log.value

  #     retention_policy {
  #       enabled = false
  #     }
  #   }
  # }

  enabled_log {
    category = "ApplicationGatewayAccessLog"
  }

  enabled_log {
    category = "ApplicationGatewayFirewallLog"
  }

  enabled_log {
    category = "ApplicationGatewayPerformanceLog"
  }

  # dynamic "metric" {
  #   for_each = local.diag_appgtw_metrics
  #   content {
  #     category = metric.value

  #     retention_policy {
  #       enabled = false
  #     }
  #   }
  # }

  /*enabled_metric {
    category = "AllMetrics"
  }*/
}
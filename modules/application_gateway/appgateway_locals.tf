locals {
  default_tags = merge(var.default_tags, { "Environment" = "${terraform.workspace}" })
  environment  = terraform.workspace != "default" ? terraform.workspace : ""
}

# Create local variables for Application Gateway
locals {
  gateway_ip_configuration_name  = "${var.appgtw_name}-configuration"
  frontend_port_name             = "${var.appgtw_name}-feport"
  frontend_ip_configuration_name = "${var.appgtw_name}-feip"
  backend_address_pool_name      = "${var.appgtw_name}-beap"
  backend_http_settings_name     = "${var.appgtw_name}-be-http"
  http_listener_name             = "${var.appgtw_name}-http-listner"
  request_routing_rule_name      = "${var.appgtw_name}-rqrt-rule"
  # redirect_configuration_name    = "${var.appgtw_name}-rdrcfg"
  # diag_appgtw_logs = [
  #   "ApplicationGatewayAccessLog",
  #   "ApplicationGatewayPerformanceLog",
  #   "ApplicationGatewayFirewallLog",
  # ]
  # diag_appgtw_metrics = [
  #   "AllMetrics",
  # ]
}
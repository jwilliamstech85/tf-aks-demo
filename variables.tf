# ========================== root ========================================

# Service Principal
variable "sp-subscription-id" {
  description = "Id of the azure subscription where all resources will be created"
  type        = string
}
variable "sp-client-id" {
  description = "Client Id of A Service Principal or Azure Active Directory application registration used for provisioning azure resources."
  type        = string
}
variable "sp-client-secret" {
  description = "Secret of A Service Principal or Azure Active Directory application registration used for provisioning azure resources."
  type        = string
}
variable "sp-tenant-id" {
  description = "Tenant Id of the azure account."
  type        = string
}

# ========================== location ====================================
variable "location" {
  description = "Specifies the location for the resource group and all the resources"
  type        = string
  default     = "West US"
}

# ========================== log analytics workspace =====================

variable "log_analytics_workspace_rg_name" {
  description = "(Required) Specifies the resource group name of the log analytics workspace"
  type        = string
}

variable "log_analytics_workspace_name" {
  description = "(Required) Specifies the name of the log analytics workspace"
  type        = string
}

variable "log_analytics_workspace_location" {
  description = "(Required) Specifies the location of the log analytics workspace"
  type        = string
}

variable "log_analytics_workspace_sku" {
  description = "(Optional) Specifies the sku of the log analytics workspace"
  type        = string
  default     = "PerGB2018"

  validation {
    condition     = contains(["Free", "Standalone", "PerNode", "PerGB2018"], var.log_analytics_workspace_sku)
    error_message = "The log analytics sku is incorrect."
  }
}

variable "log_analytics_retention_days" {
  description = " (Optional) Specifies the workspace data retention in days. Possible values are either 7 (Free Tier only) or range between 30 and 730."
  type        = number
  default     = 30
}

# ========================== virtual netowrking ==========================

variable "hub_vnet_rg_name" {
  description = "Name of the resource group name for virtual network"
  type        = string
}

variable "hub_location" {
  description = "Location of the resource group for the hub virtual network"
  type        = string
}

variable "hub_vnet_location" {
  description = "Location in which to deploy the virtual network"
  type        = string
}

variable "hub_vnet_name" {
  description = "Name of the hub virtual network"
  type        = string
}

variable "hub_vnet_address_space" {
  description = "Specifies the address space of the hub virtual virtual network"
  type        = list(string)
}

variable "hub_gateway_subnet_name" {
  description = "Specifies the name of the gateway subnet"
  type        = string
}

variable "hub_gateway_subnet_address_prefixes" {
  description = "Specifies the address prefix of the hub gateway subnet"
  type        = list(string)
}

variable "hub_bastion_subnet_name" {
  description = "Specifies the name of the hub vnet AzureBastion subnet"
  type        = string
}

variable "hub_bastion_subnet_address_prefixes" {
  description = "Specifies the address prefix of the hub bastion host subnet"
  type        = list(string)
}

variable "hub_firewall_subnet_name" {
  description = "Specifies the name of the azure firewall subnet"
  type        = string
}

variable "hub_firewall_subnet_address_prefixes" {
  description = "Specifies the address prefix of the azure firewall subnet"
  type        = list(string)
}

variable "spoke_vnet_name" {
  description = "Specifies the name of the spoke virtual virtual network"
  type        = string
}

variable "spoke_vnet_address_space" {
  description = "Specifies the address space of the spoke virtual virtual network"
  type        = list(string)
}

variable "jumpbox_subnet_name" {
  description = "Specifies the name of the jumpbox subnet"
  type        = string
}

variable "jumpbox_subnet_address_prefix" {
  description = "Specifies the address prefix of the jumbox subnet"
  type        = list(string)
}

variable "aks_subnet_name" {
  description = "Specifies the name of the aks subnet"
  type        = string
}

variable "aks_address_prefixes" {
  type = list(string)
}

variable "appgtw_subnet_name" {
  description = "Specifies the name of the application gateway subnet"
  type        = string
}

variable "appgtw_address_prefixes" {
  type = list(string)
}

variable "psql_subnet_name" {
  description = "Specifies the name of the psql subnet"
  type        = string
}

variable "psql_address_prefixes" {
  type = list(string)
}

variable "gateway_subnet_address_prefixes" {
  type = list(string)
}

variable "vpn_gateway_subnet_address_prefixes" {
  type = list(string)
}

# ========================== azure container registry =====================
variable "acr_name" {
  description = "(Required) Specifies the name of the Container Registry. Changing this forces a new resource to be created."
  type        = string
}

variable "acr_rg_name" {
  description = "(Required) The name of the resource group in which to create the Container Registry. Changing this forces a new resource to be created."
  type        = string
}

variable "acr_location" {
  description = "Location in which to deploy the Container Registry"
  type        = string
  #default     = "West US"
}

variable "acr_admin_enabled" {
  description = "(Optional) Specifies whether the admin user is enabled. Defaults to false."
  type        = string
  default     = false
}

variable "acr_sku" {
  description = "(Optional) The SKU name of the container registry. Possible values are Basic, Standard and Premium. Defaults to Basic"
  type        = string
  #default     = "Basic"

  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.acr_sku)
    error_message = "The container registry sku is invalid."
  }
}
variable "acr_georeplication_locations" {
  description = "(Optional) A list of Azure locations where the container registry should be geo-replicated."
  type        = list(string)
  #default     = ["Central US", "West US"]
}

/*variable "acr_log_analytics_retention_days" {
  description = "Specifies the number of days of the retention policy"
  type        = number
  #default     = 7
}*/

variable "acr_tags" {
  description = "(Optional) Specifies the tags of the ACR"
  type        = map(any)
  default     = {}
}

variable "acr_data_endpoint_enabled" {
  description = "(Optional) Whether to enable dedicated data endpoints for this Container Registry? Defaults to false. This is only supported on resources with the Premium SKU."
  type        = bool
  #default     = true
}

variable "pe_acr_subresource_names" {
  description = "(Optional) Specifies a subresource names which the Private Endpoint is able to connect to ACR."
  type        = list(string)
  #default     = ["registry"]
}

#modules/log_analytics_workspace/law_outputs.tf/azurerm_log_analytics_workspace.workspace_id
#variable "output_law_id" {
#description = "Workspace id from law module outputs"
#type        = string
#}

# ========================== bastion host ================================
variable "bastion_name" {
  description = "Specifies the name of the bastion host"
  type        = string
}

variable "bastion_subnet_name" {
  description = "Specifies the name of the bastion subnet"
  type        = string
}

variable "bastion_rg_name" {
  description = "Specifies the name of the resource group for the bastion host"
  type        = string
}

variable "bastion_pip_name" {
  description = "Specifies the name of the public IP address for the bastion host"
  type        = string
  #default = "tf-aks-demo-bastion-pip"
}

variable "bastion_sku" {
  description = "Specifies the SKU of the bastion host"
  type        = string
  #default        = "basic"
}

# ========================== jumpbox =====================================
variable "jumpbox_rg_name" {
  description = "Specifies the name of the resource group for the jumpbox"
  type        = string
}

variable "jumpbox_location" {
  description = "Specifies the location of the jumpbox"
  type        = string
}

variable "jumpbox_admin_username" {
  description = "Specifies the admin username of the jumpbox"
  type        = string
  sensitive   = true
}

variable "jumpbox_admin_password" {
  description = "Specifies the admin password of the jumpbox"
  type        = string
  sensitive   = true
}

variable "nsg_allowed_ip_range" {
  description = "Specifies the allowed IP range to connect to the jumpbox NSG"
  type        = string
}
# ========================== tags ========================================

variable "default_tags" {
  type = map(any)
  default = {
    "Project"   = "TF-AKS-Demo"
    "Owner"     = "Joshua Williams"
    "CreatedBy" = "Joshua Williams"
  }
}

// ========================== virtual netowrking ==========================

variable "vnet_rg_name" {
  description = "Name of the resource group name for virtual network"
  type        = string
  #default     = "tf-aks-vnet"
}

variable "vnet_location" {
  description = "Location in which to deploy the virtual network"
  type        = string
  #default     = "West US"
}

variable "hub_vnet_name" {
  description = "Specifies the name of the hub virtual virtual network"
  type        = string
  #default     = "tf-aks-hub"
}

variable "hub_vnet_address_space" {
  description = "Specifies the address space of the hub virtual virtual network"
  type        = list(string)
  #default     = ["10.63.0.0/20"]
}


variable "hub_gateway_subnet_name" {
  description = "Specifies the name of the gateway subnet"
  type        = string
  #default     = "gateway"
}

variable "hub_gateway_subnet_address_prefixes" {
  description = "Specifies the address prefix of the hub gateway subnet"
  type        = list(string)
  #default     = ["10.63.0.0/25"]
}

variable "hub_bastion_subnet_name" {
  description = "Specifies the name of the hub vnet AzureBastion subnet"
  type        = string
  #default     = "bastion"
}

variable "hub_bastion_subnet_address_prefixes" {
  description = "Specifies the address prefix of the hub bastion host subnet"
  type        = list(string)
  #default     = ["10.63.0.128/28"]
}

variable "hub_firewall_subnet_name" {
  description = "Specifies the name of the azure firewall subnet"
  type        = string
  #default     = "hub-firewall"
}

variable "hub_firewall_subnet_address_prefixes" {
  description = "Specifies the address prefix of the azure firewall subnet"
  type        = list(string)
  #default     = ["10.63.2.0/24"]
}

variable "spoke_vnet_name" {
  description = "Specifies the name of the spoke virtual virtual network"
  type        = string
  #default     = "spoke"
}

variable "spoke_vnet_address_space" {
  description = "Specifies the address space of the spoke virtual virtual network"
  type        = list(string)
  #default     = ["10.64.0.0/16"]
}

variable "jumpbox_subnet_name" {
  description = "Specifies the name of the jumpbox subnet"
  type        = string
  #default     = "jumpbox"
}

variable "jumpbox_subnet_address_prefix" {
  description = "Specifies the address prefix of the jumbox subnet"
  type        = list(string)
  #default     = ["10.64.3.0/28"]
}

variable "aks_subnet_name" {
  description = "Specifies the name of the aks subnet"
  type        = string
  #default     = "aks"
}

variable "aks_address_prefixes" {
  type = list(string)
  #default = ["10.64.4.0/22"]
}

variable "appgtw_subnet_name" {
  description = "Specifies the name of the application gateway subnet"
  type        = string
  #default     = "appgtw"
}

variable "appgtw_address_prefixes" {
  type = list(string)
  #default = ["10.63.1.0/28"]
}

variable "psql_subnet_name" {
  description = "Specifies the name of the psql subnet"
  type        = string
  #default     = "psql"
}

variable "psql_address_prefixes" {
  type = list(string)
  #default = ["10.64.2.0/26"]
}

variable "vnet_log_analytics_retention_days" {
  description = "Specifies the number of days of the retention policy"
  type        = number
  default     = 30
}

variable "vnet_tags" {
  description = "(Optional) Specifies the tags of the virtual network"
  type        = map(any)
  default     = {}
}

variable "gateway_subnet_address_prefixes" {
  type = list(string)
  #default = ["10.64.0.0/26"]
}

variable "vpn_gateway_subnet_address_prefixes" {
  type = list(string)
  #default = ["10.64.0.128/28"]
}

variable "default_tags" {
  type = map(any)
  default = {
    "Project"   = "TF-AKS-Demo"
    "Owner"     = "Joshua Williams"
    "CreatedBy" = "Joshua Williams"
  }
}
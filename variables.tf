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
# Azure resources
/*variable "rg_name" {
  description = "Name of the main resource group name for the project"
  type        = string
  default     = "tf-aks-demo"
}*/

variable "location" {
  description = "Specifies the location for the resource group and all the resources"
  type        = string
  default     = "West US"
}

variable "default_tags" {
  type = map(any)
  default = {
    "Project"   = "TF-AKS-Demo"
    "Owner"     = "Joshua Williams"
    "CreatedBy" = "Joshua Williams"
  }
}
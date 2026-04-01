variable "vnet_rg_suffix" {
  type        = string
  default     = "rg"
  description = "Suffix of the resource group name that's combined with name of the resource group."
}

variable "vnet_suffix" {
  type        = string
  default     = "vnet"
  description = "Suffix of the vnet name."
}

variable "subnet_suffix" {
  type        = string
  default     = "snet"
  description = "Suffix of the Subnet name."
}
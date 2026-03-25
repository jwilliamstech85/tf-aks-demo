variable "rg_name" {
  description = "Name of the main resource group name for the project"
  type        = string
  default     = "tf-aks-demo"
}

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
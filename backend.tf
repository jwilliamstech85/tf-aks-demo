terraform {
  backend "azurerm" {
    resource_group_name  = "SA_RG"
    storage_account_name = "jwilliamstechtfstatemgmt"
    container_name       = "tfstatemgmt"
    key                  = "tf-aks-state"
  }
}
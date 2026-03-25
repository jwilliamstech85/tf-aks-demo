# Create the resource group
resource "azurerm_resource_group" "rg" {
  name     = lower("${var.rg_name}-${local.environment}-${var.rg_suffix}")
  location = var.location
  tags = merge(local.default_tags,
    {
      "CreatedBy" = "Joshua Williams"
  })
  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}
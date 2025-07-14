resource "azurerm_resource_group" "rg_block" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

variable "resource_group_name" {}
variable "resource_group_location" {}

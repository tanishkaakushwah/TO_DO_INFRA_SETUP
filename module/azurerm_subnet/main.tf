resource "azurerm_subnet" "subnet_block" {
  name                 = var.subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = var.address_prefixes
}

variable "subnet_name" {}
variable "resource_group_name" {}
variable "vnet_name" {}
variable "address_prefixes" {}

output "subnet_id" {
  value = azurerm_subnet.subnet_block.id
}

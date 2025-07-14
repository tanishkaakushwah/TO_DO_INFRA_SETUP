resource "azurerm_public_ip" "pip_block" {
  name                = var.pip_name
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
}

variable "pip_name" {}
variable "resource_group_name" {}
variable "location" {}

output "pip_id" {
  value = azurerm_public_ip.pip_block.id
}
output "ip_address" {
  value = azurerm_public_ip.pip_block.ip_address

}
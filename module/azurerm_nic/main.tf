resource "azurerm_network_interface" "nic_block" {
  name                = var.nic_name
  location            = var.location
  resource_group_name = var.resource_group_name
  
    ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id 
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.public_ip_address_id
  }
}
variable "nic_name" {}
variable "location" {}
variable "resource_group_name" {}
variable "subnet_id" {}
variable "public_ip_address_id" {}

output "nic_id" {
  value = azurerm_network_interface.nic_block.id
}




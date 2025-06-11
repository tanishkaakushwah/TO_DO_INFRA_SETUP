resource "azurerm_linux_virtual_machine" "vm_block" {
  name                = var.vm_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password = "Admin@1234"
  disable_password_authentication = false
  network_interface_ids = var.network_interface_ids

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.publisher_id
    offer     = var.product_id
    sku       = var.plan_id
    version   = "latest"
  }
}

variable "vm_name" {}
variable "resource_group_name" {}
variable "location" {}
variable "network_interface_ids" {}
variable "publisher_id" {}
variable "product_id" {}
variable "plan_id" {}
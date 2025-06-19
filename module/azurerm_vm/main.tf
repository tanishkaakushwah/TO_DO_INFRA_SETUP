data "azurerm_subnet" "subnet_data" {
  name                 = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.resource_group_name
}
data "azurerm_public_ip" "pip_data" {
  name                = var.pip_name
  resource_group_name = var.resource_group_name
}
resource "azurerm_network_interface" "nic_block" {
  name                = var.nic_name
  location            = var.location
  resource_group_name = var.resource_group_name
  
    ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.subnet_data.id 
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = data.azurerm_public_ip.pip_data.id  
  }
}
data "azurerm_key_vault" "kv_data" {
  name                = var.kv_name
  resource_group_name = var.resource_group_name
}
data "azurerm_key_vault_secret" "pswd" {
  name         = "vm-pswd"
  key_vault_id = data.azurerm_key_vault.kv_data.id
}


resource "azurerm_linux_virtual_machine" "vm_block" {
  name                = var.vm_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_F2"
  admin_username      = "k636945"
  admin_password      = data.azurerm_key_vault_secret.pswd.value
  disable_password_authentication = false
  network_interface_ids = [azurerm_network_interface.nic_block.id]
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
variable "publisher_id" {}
variable "product_id" {}
variable "plan_id" {}
variable "nic_name" {}
variable "subnet_name" {}
variable "vnet_name" {}
variable "pip_name" {}
variable "kv_name" {}
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

resource "azurerm_network_security_group" "nsg_block" {
  count               = var.vm_name == "frontend-vm" ? 1 : 0
  name                = var.nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "http-allow"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "ssh-allow"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "nic-nsg" {
  count                     = var.vm_name == "frontend-vm" ? 1 : 0
  network_interface_id      = azurerm_network_interface.nic_block.id
  network_security_group_id = azurerm_network_security_group.nsg_block[0].id
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
  name                            = var.vm_name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  size                            = "Standard_F2"
  admin_username                  = "k636945"
  admin_password                  = data.azurerm_key_vault_secret.pswd.value
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.nic_block.id]
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
  custom_data = var.vm_name == "frontend-vm" ? base64encode(<<-EOF
    #!/bin/bash
    sudo apt-get update
    sudo apt-get install -y nginx
    sudo systemctl start nginx
    sudo systemctl enable nginx
  EOF
  ) : null
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
variable "nsg_name" {}
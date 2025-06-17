resource "azurerm_mssql_server" "server_block" {
  name                         = var.server_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.admin_login
  administrator_login_password = var.admin_pswd
}

variable "server_name" {}
variable "resource_group_name" {}
variable "location" {}
variable "admin_login" {}
variable "admin_pswd" {}
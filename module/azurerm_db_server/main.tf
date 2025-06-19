data "azurerm_key_vault" "kv_data" {
  name                = var.kv_name
  resource_group_name = var.resource_group_name
}

data "azurerm_key_vault_secret" "db_pswd" {
  name         = "db-pswd"
  key_vault_id = data.azurerm_key_vault.kv_data.id
}

resource "azurerm_mssql_server" "server_block" {
  name                         = var.server_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.admin_login
  administrator_login_password = data.azurerm_key_vault_secret.db_pswd.value
}

variable "server_name" {}
variable "resource_group_name" {}
variable "location" {}
variable "admin_login" {}
variable "kv_name" {}
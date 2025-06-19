data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv_block" {
  name                        = var.kv_name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = true
  sku_name = var.sku_name
  enable_rbac_authorization  = true
}

resource "random_password" "vm_password" {
  length  = 16
  special = true
}
resource "random_password" "db_password" {
  length  = 16
  special = true
}

resource "azurerm_key_vault_secret" "sec_block" {
  name         = "vm-pswd"
  value        = random_password.vm_password.result
  key_vault_id = azurerm_key_vault.kv_block.id
}
resource "azurerm_key_vault_secret" "db_sec_block" {
  name         = "db-pswd"
  value        = random_password.db_password.result
  key_vault_id = azurerm_key_vault.kv_block.id
}

variable "kv_name" {}
variable "location" {}
variable "resource_group_name" {}
variable "sku_name" {}
